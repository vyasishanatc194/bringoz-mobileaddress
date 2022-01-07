//
//  ViewController.swift
//  Bringoz
//
//  Created by Sandip Soni on 03/01/22.
//

import UIKit
import GooglePlaces
import RxSwift

protocol AddAddressDelegate {
    func addAddress(place : Address)
}

class AddAddressViewController: UIViewController {
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var searchView: UIView!
    
    var delegate: AddAddressDelegate?
    private let placeProvider: PlaceProvider = AddressModule.shared.getPlaceProvider()
    private var disposable: Disposable?
    private var addresses : [Address] = []
    
    private var addAddressViewModel: AddAddressViewModel!
    
    private let disposables: CompositeDisposable = CompositeDisposable()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addAddressViewModel = AddressModule.shared.getAddAddressViewModel()
        setUpUI()
        observeForAddresses()
    }
    
    func setUpUI() {
        nameTF.becomeFirstResponder()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        searchView.layer.masksToBounds = false
        searchView.layer.shadowColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        searchView.layer.shadowOpacity = 1
        searchView.layer.shadowOffset = CGSize(width: 0, height: 4)
        searchView.layer.shadowRadius = 20
        
        searchView.layer.shadowPath = UIBezierPath(rect: searchView.bounds).cgPath
        searchView.layer.shouldRasterize = true
    }
    
    override func didReceiveMemoryWarning() {
        addresses = []
    }
    
    @IBAction func onBackPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didChangeText(_ sender: UITextField) {
        addAddressViewModel.queryStream.onNext(sender.text ?? "")
    }
    
    private func observeForAddresses() {
        _ = disposables.insert(addAddressViewModel.getAddressesStateStream.subscribe(onNext: { state in
            let loading = state?.loading == true
            self.loading.isHidden = !loading
            
            if (state?.completed == true) {
                guard let addresses = state?.data?.addresses else {
                    return
                }
                
                self.addresses = addresses
                self.tableview.reloadData()
            }
                
        }, onError: { error in
            
        }, onCompleted: {
            
        }))
    }
    
    private func getAddressDetails(placeID: String) {
        _ = disposables.insert(addAddressViewModel.getAddressDetailsStateStream.subscribe(onNext: { state in
            let loading = state?.loading == true
            self.loading.isHidden = !loading
            if (state?.completed == true) {
                self.delegate?.addAddress(place: state!.data!)
                self.navigationController?.popViewController(animated: true)
            }
                
        }, onError: { error in
            
        }, onCompleted: {
            
        }))
        addAddressViewModel.getAddressDetails(placeID: placeID)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        addAddressViewModel.dispose()
        disposables.dispose()
    }
}

// MARK: - TextFieldDelegate
extension AddAddressViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

// MARK: - table view methods
extension AddAddressViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addresses.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SearchAddressTableViewCell", for: indexPath) as? SearchAddressTableViewCell {
            cell.nameLabel.text = addresses[indexPath.row].name
            return cell
        }
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        getAddressDetails(placeID: addresses[indexPath.row].placeID)
        self.resignFirstResponder()
        tableview.deselectRow(at: indexPath, animated: false)
    }
    
}
