//
//  AddLocationViewController.swift
//  miniProject
//
//  Created by 楷岷 張 on 2017/4/8.
//  Copyright © 2017年 楷岷 張. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class AddPlaceViewController: ParentViewController {
    
    var album: AlbumModel?
    private var addPlaceData = AddPlaceModel()
    
    lazy var addPlaceView: AddPlaceView = {
        return AddPlaceView(delegate: self)
    }()
    
    lazy private var datePickerView: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "Chinese")
        return datePicker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUserInterface()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - private Method
    
    private func setUserInterface() {
        setNavigation(title: "Add Place", barButtonType: .Dismiss_)
        view.backgroundColor = .clear
        
        view.addSubview(addPlaceView)
        
        view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[addPlaceView]|",
            options: [],
            metrics: nil,
            views: ["addPlaceView": addPlaceView]))
        
        view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-\(navigationHeight)-[addPlaceView]|",
            options: [],
            metrics: nil,
            views: ["addPlaceView": addPlaceView]))
        
        setTextField()
    }
    
    private func setTextField() {
        addPlaceView.selectLocationTextField.addTarget(self, action: #selector(setSearchPlaceVC), for: .editingDidBegin)
        addPlaceView.selectLocationTextField.inputView = nil
        guard let album = album else { return }
        datePickerView.minimumDate = Date(timeIntervalSince1970: album.startTime)
        datePickerView.maximumDate = Date(timeIntervalSince1970: album.startTime.calculationEndTimeInterval(with: album.day))
        addPlaceData.time = album.startTime
        datePickerView.date = Date(timeIntervalSince1970: album.startTime)
        addPlaceView.selectPhotoDayTextField.text = album.startTime.dateToString(type: .all)
        addPlaceView.selectPhotoDayTextField.inputView = datePickerView
        addPlaceView.selectPhotoDayTextField.tintColor = .clear
        addPlaceView.selectPhotoDayTextField.inputAccessoryView = TAToolBar(cancelAction: { [weak self] in
                self?.addPlaceView.selectPhotoDayTextField
                    .resignFirstResponder()
            }, checkAction: { [weak self] in
                self?.addPlaceData.time = self?.datePickerView.date.timeIntervalSince1970 ?? 0.0
                self?.addPlaceView.selectPhotoDayTextField.text = (self?.addPlaceData.time ?? 0.0).dateToString(type: .all)
                self?.addPlaceView.selectPhotoDayTextField
                    .resignFirstResponder()
            })
    }
    
    // MARK: - Action Method
    
    @objc private func setSearchPlaceVC() {
        guard isNetworkConnected() else { return }
        let searchPlaceVC = SearchPlaceViewController()
        searchPlaceVC.delegate = self
        present(searchPlaceVC, animated: true, completion: nil)
    }
}

    // MARK: - AddPlaceDelegate

extension AddPlaceViewController: AddPlaceDelegate {
    func addPlaceButtonDidPressed() {
        guard !addPlaceData.placeName.isEmpty, let album = album else {
            showAlert(type: .check, title: "請選擇拍照地點")
            return
        }
        startLoading()
        FirebaseManager.shared.addNewPlaceData(albumid: album.id, placeData: addPlaceData) { [weak self] (error) in
            self?.stopLoading()
            guard error == nil else {
                self?.showAlert(type: .check, title: error?.localizedDescription ?? "")
                return
            }
            self?.dismiss(animated: true, completion: nil)
        }
    }
}

    // MARK: - GMSAutocompleteViewControllerDelegate

extension AddPlaceViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        addPlaceView.selectLocationTextField.text = place.name
        addPlaceData.placeName = place.name ?? ""
        addPlaceData.longitude = place.coordinate.longitude
        addPlaceData.latitude = place.coordinate.latitude
    
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        showAlert(type: .check, title: error.localizedDescription)
    }

    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
}
