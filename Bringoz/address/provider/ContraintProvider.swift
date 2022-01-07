//
//  ContraintProvider.swift
//  Bringoz
//
//  Created by Sandip Soni on 06/01/22.
//

import UIKit

/*
    Defines what a constraint should be.
 */
protocol Constraint {
    func shouldAllow(from fromAddress: Address,to toAddress: Address,sourceAddress: Address) -> Bool
}

/*
    Constraints which enforces the linked addresses to be next to each other and doesn't allow any other addresses in between
 */
class AdjacentConstraint : Constraint {
    
    func shouldAllow(from fromAddress: Address, to toAddress: Address, sourceAddress: Address) -> Bool {
        return false
    }
}

/*
  Constraint which allows addresses in between the constrained addresses as long as the ETA of the destination constrained
  address is less than the specified minute
 */
class MaxMinutesConstraint : Constraint {
    // Minute threshold
    private let minutes: Int
    
    init(minutes: Int) {
        self.minutes = minutes
    }

    func shouldAllow(from fromAddress: Address, to toAddress: Address, sourceAddress: Address) -> Bool {
        // TODO: Place the actual logic here. This is just to demonstrate that
        // the constraints are abstract in the rest of the app and hence they
        // can be easily swaped with each other
        return false
    }
    
}
