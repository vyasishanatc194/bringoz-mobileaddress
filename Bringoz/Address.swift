//
//  Address.swift
//  Bringoz
//
//  Created by Sandip Soni on 04/01/22.
//

import Foundation

class Address {
    var placeID:String
    var name: String
    var latitude: Double?
    var longitude: Double?
    var arrivalDateTime: Date?
    
    init(placeID: String,name: String,latitude: Double?,longitude: Double?) {
        self.placeID = placeID
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
}
