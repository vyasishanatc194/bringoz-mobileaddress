//
//  ArielETAProvider.swift
//  Bringoz
//
//  Created by Sandip Soni on 06/01/22.
//

import Foundation
import CoreLocation

/*
  ETA provider which uses CLLocation locally in order to obtain the distance
  in meters between two addresses and estimates the time based on that.
 */
class AerialETAProvider: ETAProvider {
    var startingTime: Date
    
    init() {
        startingTime = Date.init()
    }
    
    func calculateAddressArrivalTime(address lastAddress: Address, currentAddress: Address) -> Date? {
        let distanceInMeters = distance(from: lastAddress,to: currentAddress)
        let totalTime = distanceInMeters/10
        return getNewDate(time: Int(totalTime), fromDate: lastAddress.arrivalDateTime)
    }
    
    func getNewDate(time seconds: Int, fromDate: Date?) -> Date? {
        var dateComp = DateComponents()
        dateComp.second = seconds
        if let date = fromDate {
            return Calendar.current.date(byAdding: dateComp, to: date, wrappingComponents: false)
        } else {
            return nil
        }
    }
    
    func distance(from fromAddress: Address, to toAddress: Address) -> Double {
        let coordinate0 = CLLocation(latitude: fromAddress.latitude!, longitude:fromAddress.longitude!)
        let coordinate1 = CLLocation(latitude: toAddress.latitude!, longitude:toAddress.longitude!)
        let distanceInMeters = coordinate0.distance(from: coordinate1)
        return distanceInMeters
    }
    
}
