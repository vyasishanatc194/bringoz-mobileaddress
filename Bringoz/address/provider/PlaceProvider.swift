//
//  PlaceProvider.swift
//  Bringoz
//
//  Created by Sandip Soni on 06/01/22.
//

import Foundation
import RxSwift

/*
 Defines the signature for becoming a Place Provider which is used in the app to search addresses
 as user types
 */
protocol PlaceProvider{
    // Get places/addresses as per the request.query
    func getPlaces(request: GetPlacesRequest) -> Single<AddressesData>
    
    // Get detail of specific request.placeID
    func getPlaceDetails(request: GetPlaceDetailsRequest) -> Single<Address>
}

/*
 Holds necessary data for getting / searching addresses
 */
struct GetPlacesRequest {
    var query: String
    
    init(query: String) {
        self.query = query
    }
}

/*
 Holds necessary data for getting address' details
 */
struct GetPlaceDetailsRequest{
    var placeID: String
    
    init(placeID: String) {
        self.placeID = placeID
    }
}

