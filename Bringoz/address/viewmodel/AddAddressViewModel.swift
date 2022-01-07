//
//  AddAddressViewModel.swift
//  Bringoz
//
//  Created by Sandip Soni on 07/01/22.
//

import Foundation
import RxSwift

class AddAddressViewModel {
    // Rx-Stream which holds and notifies whenever search text changes
    let queryStream: BehaviorSubject<String> = BehaviorSubject(value: "")
    
    // Rx-Stream which holds and notifies about state while getting the addresses
    let getAddressesStateStream: BehaviorSubject<GetAddressesState?> = BehaviorSubject(value: nil)
    
    // Rx-Stream which holds and notifies about state while getting the address details
    let getAddressDetailsStateStream: BehaviorSubject<GetAddressDetailsState?> = BehaviorSubject(value: nil)
    
    // Helper which provides the list as per the query entered by user
    private let placeProvider: PlaceProvider
    
    // Rx clean up
    private var disposable: Disposable?
    private let disposables: CompositeDisposable = CompositeDisposable()
    
    init(placeProvider: PlaceProvider) {
        self.placeProvider = placeProvider
        observeForQueryChanges()
    }
    
    /*
            Observe for any change in the query text. As user will start typing, we need to fetch the related addresses
     */
    private func observeForQueryChanges() {
        // clear previous calls if any
        self.disposable?.dispose()
        
        self.disposable = queryStream.debounce(RxTimeInterval.milliseconds(300), scheduler: MainScheduler.instance)
            .flatMap{ query in
                // Hit the PlaceProvider to get the places/addresses
                return self.placeProvider.getPlaces(request: GetPlacesRequest(query: query)).asObservable()
                    // Once we receive the data, convert it to the completed state
                    .map({ data in
                        return GetAddressesState.completed(data: data)
                    })
                    // Start with loading state
                    .startWith(GetAddressesState.loading())
                
            }
            .subscribe(onNext: { data in
                // Add the data to the stream so UI/View can utilize it
                self.getAddressesStateStream.onNext(data)
            }, onError: { error in
                // TODO: Parse/handle errors properly
                self.getAddressesStateStream.onNext(GetAddressesState.error())
            }, onCompleted: {
                
            })
        
    }
    
    /*
            Get address's detail for the given placeID. UI should subscribe to the getAddressDetailsStateStream
            as this method will post the states update through that stream
     */
    func getAddressDetails(placeID: String) {
        _ = disposables.insert(placeProvider.getPlaceDetails(request: GetPlaceDetailsRequest(placeID: placeID))
            .asObservable()
            .map({ address in
                print("received address!")
                return GetAddressDetailsState.completed(data: address)
            })
            .startWith(GetAddressDetailsState.loading())
            .subscribe(onNext: { state in
                self.getAddressDetailsStateStream.onNext(state)
            }, onError: { error in
                self.getAddressDetailsStateStream.onNext(GetAddressDetailsState.error())
            }, onCompleted: {
                
            }))
    }
    
    func dispose() {
        disposable?.dispose()
        disposables.dispose()
    }
}
