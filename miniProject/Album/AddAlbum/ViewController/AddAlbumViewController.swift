//
//  AddViewController.swift
//  miniProject
//
//  Created by 楷岷 張 on 2017/4/8.
//  Copyright © 2017年 楷岷 張. All rights reserved.
//

import UIKit

class AddAlbunViewController: ParentViewController {
    
    private var addAlbum = AddAlbumModel()
    fileprivate var selectDay = 1
    fileprivate var dayList = (1...30).map { $0 }
    lazy private var addAlbumView: AddAlbumBackgroundView = {
        return AddAlbumBackgroundView(delegate: self, textFieldDelegate: self)
    }()
    
    lazy private var datePickerView: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "Chinese")
        return datePicker
    }()
    
    lazy private var selectDayPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    @IBAction func inputImageBotton(_ sender: UIButton) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUserInterface()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - private Method
    
    private func setUserInterface() {
        setNavigation(title: "Add Album", barButtonType: .Dismiss_)
        view.addSubview(addAlbumView)
        
        view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[addAlbumView]|",
            options: [],
            metrics: nil,
            views: ["addAlbumView": addAlbumView]))
        
        view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-\(navigationHeight)-[addAlbumView]|",
            options: [],
            metrics: nil,
            views: ["addAlbumView": addAlbumView]))
        
        setTextField()
    }
    
    private func setTextField() {
        selectDay = dayList[0]
        addAlbum.day = dayList[0]
        addAlbumView.selectDayTextField.text = "\(dayList[0])"
        addAlbumView.selectDayTextField.inputView = selectDayPickerView
        addAlbumView.selectDayTextField.inputAccessoryView = TAToolBar(cancelAction: { [weak self] in
                self?.addAlbumView.selectDayTextField
                    .resignFirstResponder()
            },  checkAction: { [weak self] in
                self?.addAlbum.day = self?.selectDay ?? 0
                self?.addAlbumView.selectDayTextField.text = "\(self?.addAlbum.day ?? 0)"
                self?.addAlbumView.selectDayTextField
                    .resignFirstResponder()
            })
        addAlbum.startTime = Date().timeIntervalSince1970
        addAlbumView.startTiemTextField.text = Date().timeIntervalSince1970.dateToString(type: .all)
        addAlbumView.startTiemTextField.inputView = datePickerView
        addAlbumView.startTiemTextField.inputAccessoryView = TAToolBar(cancelAction: { [weak self] in
                self?.addAlbumView.startTiemTextField.text = Date().timeIntervalSince1970.dateToString(type: .all)
            }, checkAction: { [weak self] in
                self?.addAlbum.startTime = self?.datePickerView.date.timeIntervalSince1970 ?? 0.0
                self?.addAlbumView.startTiemTextField.text = (self?.datePickerView.date.timeIntervalSince1970 ?? 0.0).dateToString(type: .all)
                self?.addAlbumView.startTiemTextField
                    .resignFirstResponder()
            })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

    // MARK: - UIPickerViewDelegate

extension AddAlbunViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectDay = dayList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(describing: dayList[row])
    }
}

    // MARK: - UIPickerViewDataSource

extension AddAlbunViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dayList.count
    }
}

    // MARK: - AddAlbumDelegate

extension AddAlbunViewController: AddAlbumDelegate {
    func addAlbumCoverButtonDidPressed() {
        view.endEditing(true)
        checkPermission { [weak self] in
            DispatchQueue.main.async {
            UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
                let imagePicker = UIImagePickerController()
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .photoLibrary
                imagePicker.delegate = self
                self?.present(imagePicker, animated: true, completion: nil)
            }
        }
    }
    
    func addAlbumButtonDidPressed() {
        guard let name = addAlbumView.nameTextField.text, !name.isEmpty else {
            showAlert(title: "請輸入相簿名稱")
            return
        }
        
        guard addAlbum.coverPhoto != nil else {
            showAlert(title: "請選擇封面相片")
            return
        }
        addAlbum.title = name
        startLoading()
        FirebaseManager2.shared.addNewAlbumData(model: addAlbum) { [weak self] (error) in
            self?.stopLoading()
            guard error == nil else {
                self?.showAlert(title: error?.localizedDescription ?? "")
                return
            }
            self?.dismiss(animated: true, completion: nil)
        }
    }
}

    // MARK: - UIImagePickerControllerDelegate

extension AddAlbunViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let picture = info[.originalImage] as? UIImage {
            addAlbumView.addAlbumCoverPhotoButton.setImage(nil, for: .normal)
            addAlbumView.albumCoverPhotoImageView.image = picture
            addAlbum.coverPhoto = picture
        }
        dismiss(animated: true, completion: nil)
    }
}

    // MARK: - UITextFieldDelegate

extension AddAlbunViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case addAlbumView.nameTextField:
            addAlbumView.nameTextField.resignFirstResponder()
            return false
        default:
            return true
        }
    }
}
