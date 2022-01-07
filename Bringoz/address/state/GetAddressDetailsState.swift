//
//  GetAddressDetailsState.swift
//  Bringoz
//
//  Created by Sandip Soni on 07/01/22.
//

import Foundation

/*
 Represents the state while getting the details of a selected address
 */
class GetAddressDetailsState {
    var loading: Bool
    var completed: Bool
    var hasError: Bool
    var data: Address?
    
    init(loading: Bool = false, completed: Bool = false, hasError: Bool = false, data: Address? = nil) {
        self.loading = loading
        self.completed = completed
        self.hasError = hasError
        self.data = data
    }
    
    static func loading() -> GetAddressDetailsState {
        return GetAddressDetailsState(loading: true)
    }
    
    static func completed(data: Address) -> GetAddressDetailsState {
        return GetAddressDetailsState(completed: true, data: data)
    }
    
    static func error() -> GetAddressDetailsState {
        return GetAddressDetailsState(hasError: true)
    }
}
