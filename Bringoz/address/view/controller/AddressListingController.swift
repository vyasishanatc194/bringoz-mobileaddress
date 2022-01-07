//
//  AddressListingController.swift
//  Bringoz
//
//  Created by Sandip Soni on 04/01/22.
//

import UIKit
import GooglePlaces

class AddressListingController : UIViewController, AddAddressDelegate {
    
    private var addresses : [Address] = []
    private let etaProvider: ETAProvider = AddressModule.shared.getETAProvider()
    private let constraintManager = ConstraintManager()
    
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.dragInteractionEnabled = true
        tableview.dragDelegate = self
        tableview.dropDelegate = self
    }
    
    override func didReceiveMemoryWarning() {
        addresses = []
    }
    
    @IBAction func onAddPressed(_ sender: Any) {
        if let controller = UIStoryboard.init(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "AddAddressViewController") as? AddAddressViewController{
            controller.delegate = self
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @IBAction func onResetPressed(_ sender: Any) {
        self.addresses = []
        tableview.reloadData()
    }
    
    func addAddress(place: Address) {
        addresses.append(place)
        tableview.reloadData()
    }
}

// MARK: - UITablewview methods
extension AddressListingController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        addresses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "AddressTableViewCell", for: indexPath) as? AddressTableViewCell {
            var arrivalFormattedString = "N/A"
            var arrivalFormattedTime = ""
            let address = addresses[indexPath.row]
            let isBottomConstraints = constraintManager.isSecondaryConstraint(address: address)//(addresses[safe: indexPath.row + 1]?.constraint ?? false) == false ? false : true
            let isupConstraints = constraintManager.isPrimaryConstraint(address: address)//(addresses[safe: indexPath.row ]?.constraint ?? false) == false ? false : true
            if indexPath.row == 0 {
                addresses[indexPath.row].arrivalDateTime = etaProvider.startingTime
                arrivalFormattedString = "Start: \(DateUtils.shared.formatDateToString(dateTime: etaProvider.startingTime, isDate: true)) at"
                arrivalFormattedTime = " \(DateUtils.shared.formatDateToString(dateTime: etaProvider.startingTime, isDate: false))"
            } else {
                if let expectedArrivalTime = etaProvider.calculateAddressArrivalTime(address: addresses[indexPath.row - 1], currentAddress: addresses[indexPath.row]) {
                    addresses[indexPath.row].arrivalDateTime = expectedArrivalTime
                    arrivalFormattedString = "ETA: \(DateUtils.shared.formatDateToString(dateTime: expectedArrivalTime,isDate: true)) at"
                    arrivalFormattedTime = " \(DateUtils.shared.formatDateToString(dateTime: expectedArrivalTime, isDate: false))"
                } else {
                    arrivalFormattedString = "ETA: N/A"
                }
            }
            cell.delegate = self
            cell.load(indexPath: indexPath, address: addresses[indexPath.row], arrivalDate: arrivalFormattedString, arrivalTime: arrivalFormattedTime)
            cell.bottomImageView.isHidden = !isBottomConstraints
            cell.topImageView.isHidden = !isupConstraints
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = self.addresses[sourceIndexPath.row]
        addresses.remove(at: sourceIndexPath.row)
        addresses.insert(movedObject, at: destinationIndexPath.row)
        tableview.reloadData()
    }
    
}

// MARK: - DragDelegate
extension AddressListingController: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let address = addresses[indexPath.row]
        if constraintManager.isConstrained(address: address) {
            return [UIDragItem]()
        }
      
        let dragCoordinator = CacheDragCoordinator(sourceIndexPath: indexPath)
        session.localContext = dragCoordinator
        let dragItem = UIDragItem(itemProvider: NSItemProvider(object: address.placeID as NSString))
        dragItem.localObject = address
        return [dragItem]
    }
}

// MARK: - DropDelegate
extension AddressListingController: UITableViewDropDelegate {
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        if let dragCoordinator = session.localDragSession?.localContext as? CacheDragCoordinator, session.localDragSession != nil {
            guard let destination = destinationIndexPath else {
                return UITableViewDropProposal(
                    operation: .forbidden, intent: .unspecified
                )
            }
            let sourceIndexPath = dragCoordinator.sourceIndexPath
            if(destination.row == 0) {
                return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
            } else {
                if (constraintManager.isAllowedByConstraint(source: addresses[safe: sourceIndexPath.row], destination: addresses[safe: destination.row])) {
                    return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
                } else {
                    showToast(message: "You can't drop the address here")
                    return UITableViewDropProposal(operation: .forbidden, intent: .unspecified)
                }
            }
        }
        return UITableViewDropProposal(operation: .cancel, intent: .unspecified)
    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        let items = coordinator.items
        if let item = items.first {
            var destinationIndexPath: IndexPath
            if let indexPath = coordinator.destinationIndexPath {
                destinationIndexPath = indexPath
            } else {
                let section = tableView.numberOfSections - 1
                let row = tableView.numberOfRows(inSection: section) - 1
                destinationIndexPath = IndexPath(row: row, section: section)
            }
            if let sourceIndexPath = item.sourceIndexPath {
                let moveItem = self.addresses[sourceIndexPath.row]
                self.addresses.insert(moveItem, at: destinationIndexPath.row)
            }
            tableview.reloadData()
        }
    }
}

// MARK: - TableViewCellDelegate
extension AddressListingController : AddressTableViewCellDelegate {
    
    func didDoubleTap(indexPath: IndexPath, address: Address) {
        guard indexPath.row != 0 else {
            return
        }
        let address = addresses[indexPath.row]
        if (constraintManager.isPrimaryConstraint(address: address)) {
            constraintManager.removeConstrain(address: address)
        } else {
            let secondary = addresses[indexPath.row - 1]
            constraintManager.addConstraint(primary: address, secondary: secondary, constraint: AdjacentConstraint())
        }
        tableview.reloadData()
    }
}
