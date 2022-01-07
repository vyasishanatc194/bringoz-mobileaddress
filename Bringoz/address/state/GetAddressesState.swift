//
//  GetPlacesState.swift
//  Bringoz
//
//  Created by Sandip Soni on 07/01/22.
//

import Foundation

/*
 Represents the state while getting the addresses as user types/searches
 */
class GetAddressesState {
    var loading: Bool
    var completed: Bool
    var hasError: Bool
    var data: AddressesData?
    
    init(loading: Bool = false, completed: Bool = false, hasError: Bool = false, data: AddressesData? = nil) {
        self.loading = loading
        self.completed = completed
        self.hasError = hasError
        self.data = data
    }
    
    static func loading() -> GetAddressesState {
        return GetAddressesState(loading: true)
    }
    
    static func completed(data: AddressesData) -> GetAddressesState {
        return GetAddressesState(completed: true, data: data)
    }
    
    static func error() -> GetAddressesState {
        return GetAddressesState(hasError: true)
    }
}
