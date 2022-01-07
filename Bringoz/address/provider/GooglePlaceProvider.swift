//
//  GooglePlaceProvider.swift
//  Bringoz
//
//  Created by Sandip Soni on 06/01/22.
//

import Foundation
import RxSwift
import GooglePlaces

/*
    PlaceProvider using Google APIs
 */
class GooglePlaceProvider : PlaceProvider {
    private var placesClient: GMSPlacesClient!
    private let token = GMSAutocompleteSessionToken.init()
    
    init() {
        placesClient = GMSPlacesClient.shared()
    }
    
    func getPlaceDetails(request: GetPlaceDetailsRequest) -> Single<Address> {
        return Single<Address>.create { result in
            
            let placeId = request.placeID
            
            let placeFields: GMSPlaceField = [.placeID, .name, .formattedAddress, .coordinate]
            
            self.placesClient.fetchPlace(fromPlaceID: placeId, placeFields: placeFields, sessionToken: self.token) { (gmsPlace,error) in
                
                guard error == nil else{
                    result(.failure(error!))
                    return
                }
                
                if let place = gmsPlace, let formattedAddress = place.formattedAddress, let placeID = place.placeID {
                    let latitude = place.coordinate.latitude.magnitude
                    let longitude = place.coordinate.longitude.magnitude
                    let name = place.name ?? ""
                    let address = Address(placeID: placeID,name: name + "\n" + formattedAddress, latitude: latitude, longitude: longitude);
                    result(.success(address))
                }
                
            }
            return Disposables.create()
        }
    }
    
    func getPlaces(request: GetPlacesRequest) -> Single<AddressesData> {
        return Single<AddressesData>.create { result in
            
            let filter = GMSAutocompleteFilter()
            
            let searchString = request.query
            
            self.placesClient.findAutocompletePredictions(fromQuery: searchString, filter: filter, sessionToken: self.token) { (resplace, error) in
                
                guard error == nil else{
                    result(.failure(error!))
                    return
                }
                
                guard let places = resplace else { result(.success(AddressesData(addresses: [])))
                    return
                }
                
                let addresses = places.map {  place -> Address in
                    return Address(placeID: place.placeID, name: place.attributedFullText.string, latitude: nil, longitude: nil)
                }
                
                result(.success(AddressesData(addresses: addresses)))
                
            }
            
            return Disposables.create()
        }
    }
}
