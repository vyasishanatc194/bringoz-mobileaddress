//
//  ETAProvider.swift
//  Bringoz
//
//  Created by Sandip Soni on 04/01/22.
//

import Foundation

/*
  Provides ETA between two addresses
 */
protocol ETAProvider {
    var startingTime : Date { get set }
    func calculateAddressArrivalTime(address lastAddress: Address, currentAddress: Address) -> Date?
}
