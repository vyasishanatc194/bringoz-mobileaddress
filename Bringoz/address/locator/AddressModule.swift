//
//  AddressModule.swift
//  Bringoz
//
//  Created by Sandip Soni on 06/01/22.
//

import Foundation

/*
 Provides dependencies to the app
 */
struct AddressModule {
    static let shared = AddressModule()
    
    func getAddAddressViewModel() -> AddAddressViewModel {
        return AddAddressViewModel(placeProvider: getPlaceProvider())
    }
    
    func getPlaceProvider() -> PlaceProvider {
        return GooglePlaceProvider()
    }
    
    func getETAProvider() -> ETAProvider {
        return AerialETAProvider()
    }
}
