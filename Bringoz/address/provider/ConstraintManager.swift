//
//  ConstraintManager.swift
//  Bringoz
//
//  Created by Sandip Soni on 07/01/22.
//

import Foundation

/*
  Manages constraints between the addresses
 */
class ConstraintManager {
    
    // Holds the applied constraints
    private var constraints: [ConstraintData] = []
    
    /*
      Add given constraint between primary and secondary addresses
      Here primary constraint is the one on which the user tapped and
      the secondary is the one which is above of the primary one
     */
    func addConstraint(primary: Address, secondary: Address, constraint: Constraint) {
        
        if (!isPrimaryConstraint(address: primary)) {
            constraints.append(ConstraintData(primary: primary, secondary: secondary, constraint: constraint))
        } else {
            // Inform user about existing constraint!
            print("It's already constrained!")
        }
    }
    
    /*
      Remove constraints from the given address
     */
    func removeConstrain(address: Address) {
        constraints.removeAll { (data) -> Bool in
            data.primary.placeID == address.placeID
        }
    }
    
    /*
      Check if the given address is constrained in some way, either primary or secondary
     */
    func isConstrained(address: Address) -> Bool {
        return isPrimaryConstraint(address: address) || isSecondaryConstraint(address: address)
    }
    
    
//    func isBetweenContraintedIndexes(source: Address, next: Address) -> Bool {
//        if (isPrimaryConstraint(address: destination)) {
//
//        }
//    }
    
    /*
      Check if the drag-n-drop operation is allowed by the constraints applied to the destination address.
     
      if there's no constrained applied, this will return true else, it'll let the constraint decide for the same
     */
    func isAllowedByConstraint(source: Address?, destination: Address?) ->  Bool {
        if (source == nil || destination == nil) { return false }
        var constraintData = getConstraintDataForPrimary(address: destination!)
        if (constraintData == nil) {
            constraintData = getConstraintDataForSecondary(address: destination!)
        }
        if (constraintData == nil) { return true }
        return constraintData!.constraint.shouldAllow(from: constraintData!.secondary, to: constraintData!.primary, sourceAddress: source!)
    }
    
    /*
      Checks if the address is having secondary constraint
     */
    func isSecondaryConstraint(address: Address) -> Bool {
        let existingConstraint = constraints.first { (data) -> Bool in
            return data.secondary.placeID == address.placeID
        }
        
        return existingConstraint != nil
    }
    
    /*
      Checks if the address is having primary
     */
    func isPrimaryConstraint(address: Address) -> Bool {
        let existingConstraint = getConstraintDataForPrimary(address: address)
        return existingConstraint != nil
    }
    
    /*
      Internal method which checks the existing constraints if there's any primary constraint
      for the given address
     */
    private func getConstraintDataForPrimary(address: Address) -> ConstraintData? {
        let existingConstraint = constraints.first { (data) -> Bool in
            return data.primary.placeID == address.placeID
        }
        
        return existingConstraint
    }
    
    /*
      Internal method which checks the existing constraints if there's any secondary constraint
      for the given address
     */
    private func getConstraintDataForSecondary(address: Address) -> ConstraintData? {
        let existingConstraint = constraints.first { (data) -> Bool in
            return data.secondary.placeID == address.placeID
        }
        
        return existingConstraint
    }
}

/*
  Holds the constrained related data
 */
struct ConstraintData {
    /*
      Primary address, i.e the address on which user had tapped
      to initate constraint
     */
    var primary: Address
    /*
      Secondary address, i.e the address above the primary constraints, to which, the
      primary constraint is attached
     */
    var secondary: Address
    /*
      Applied Constraint
     */
    var constraint: Constraint
    
    init(primary: Address, secondary: Address, constraint: Constraint) {
        self.primary = primary
        self.secondary = secondary
        self.constraint = constraint
    }
}
