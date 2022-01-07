//
//  AddressTableViewCell.swift
//  Bringoz
//
//  Created by Sandip Soni on 04/01/22.
//

import UIKit

protocol AddressTableViewCellDelegate {
    func didDoubleTap(indexPath: IndexPath,address: Address)
//    func didLongPress(indexPath: IndexPath,address: Address)
}

class AddressTableViewCell: UITableViewCell {
    
    var delegate : AddressTableViewCellDelegate?
    var address: Address?
    var indexPath: IndexPath?
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var bottomImageView: UIImageView!
    @IBOutlet weak var topImageView: UIImageView!
    
    func load(indexPath: IndexPath,address: Address, arrivalDate: String, arrivalTime: String) {
        addGestures()
        addressLabel.text = address.name
        let attributes = [NSAttributedString.Key.foregroundColor : UIColor(named: "primaryGray")!]
        let date = NSMutableAttributedString(string: arrivalDate, attributes: attributes)
        let greenFontAttribute = [NSAttributedString.Key.foregroundColor : UIColor(named: "primaryGreen")!]
        let time = NSMutableAttributedString(string: arrivalTime, attributes: greenFontAttribute)
        date.append(time)
        distanceLabel.attributedText = date
        self.address = address
        self.indexPath = indexPath
    }
    
    func addGestures() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapFunc))
        doubleTap.numberOfTapsRequired = 2
        self.addGestureRecognizer(doubleTap)
    }
    
    @objc func doubleTapFunc() {
        if let address = self.address, let indexPath = self.indexPath{
            delegate?.didDoubleTap(indexPath: indexPath,address: address)
        }
    }
    
}
