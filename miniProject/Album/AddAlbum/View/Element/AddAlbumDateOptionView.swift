//
//  AddAlbumDateOptionView.swift
//  miniProject
//
//  Created by Min on 2020/2/4.
//  Copyright © 2020 楷岷 張. All rights reserved.
//

import UIKit

enum AddAlbumDateType {
  case date, day, none
}

extension AddAlbumDateType {
  var title: String {
    switch self {
      case .date:
        return "出發日期"
      case .day:
        return "天數"
      case .none:
        return ""
    }
  }
}

protocol AddAlbumDateOptionDelegate: class {
  func didSelectDateOption(with date: TimeInterval)
  func didSelectDayOption(with day: Int)
  func textFieldEditingDidBegin(with type: AddAlbumDateType)
}

class AddAlbumDateOptionView: UIView {

  lazy private var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: 14)
    return label
  }()

  lazy private var inputTextField: UITextField = {
    let textField = UITextField()
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.borderStyle = .none
    textField.tintColor = .clear
    textField.addTarget(self, action: #selector(inputTextFieldEditingBegin), for: .editingDidBegin)
    return textField
  }()

  lazy private var bottomLine: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .gray_A30
    return view
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

  private var viewType: AddAlbumDateType = .date
  private var selectDay: Int = 0
  private var albumInfo: AddAlbumModel?
  private var dayOptionList = [Int]()
  weak var delegate: AddAlbumDateOptionDelegate?

  init(type: AddAlbumDateType, dayOptionList: [Int], delegate: AddAlbumDateOptionDelegate? = nil) {
    self.viewType = type
    self.dayOptionList = dayOptionList
    self.delegate = delegate
    super.init(frame: .zero)
    setUserInterface()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setInfo(with info: AddAlbumModel) {
    albumInfo = info
    switch viewType {
      case .date:
        inputTextField.text = info.startTime.dateToString(type: .all)
        datePickerView.date = Date(timeIntervalSince1970: info.startTime)
      case .day:
        inputTextField.text = "\(info.day)"
        selectDayPickerView.selectRow(info.day - 1, inComponent: 0, animated: false)
      default:
        break
    }
  }

  // MARK: - Private Methods

  private func setUserInterface() {
    translatesAutoresizingMaskIntoConstraints = false
    addSubviews([titleLabel, inputTextField, bottomLine])
    setUpLayout()
    titleLabel.text = viewType.title
    bottomLine.isHidden = viewType == .day
    switch viewType {
      case .date:
      inputTextField.inputView = datePickerView
      inputTextField.inputView?.backgroundColor = .white
      inputTextField.inputAccessoryView = TAToolBar(cancelAction: { [weak self] in
        self?.inputTextField.text = self?.albumInfo?.startTime.dateToString(type: .all)
        self?.inputTextField.resignFirstResponder()
      }, checkAction: { [weak self] in
        self?.delegate?.didSelectDateOption(with: self?.datePickerView.date.timeIntervalSince1970 ?? 0.0)
        self?.inputTextField.resignFirstResponder()
      })
      case .day:
        inputTextField.inputView = selectDayPickerView
        inputTextField.inputView?.backgroundColor = .white
        inputTextField.inputAccessoryView = TAToolBar(cancelAction: { [weak self] in
          self?.inputTextField.resignFirstResponder()
        },  checkAction: { [weak self] in
          self?.delegate?.didSelectDayOption(with: self?.selectDay ?? 0)
          self?.inputTextField.resignFirstResponder()
        })
      default:
        break
    }
  }

  private func setUpLayout() {
    let views: [String: Any] = ["titleLabel": titleLabel, "inputTextField": inputTextField, "bottomLine": bottomLine]

    addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "H:|-10-[titleLabel]-10-|",
      options: [],
      metrics: nil,
      views: views))

    addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "H:|-10-[inputTextField]-10-|",
      options: [],
      metrics: nil,
      views: views))

    addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "H:|[bottomLine]|",
      options: [],
      metrics: nil,
      views: views))

    addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "V:|-5-[titleLabel(15)]-5-[inputTextField][bottomLine(1)]|",
      options: [],
      metrics: nil,
      views: views))
  }

  // MARK: - Action Methods

  @objc private func inputTextFieldEditingBegin() {
    delegate?.textFieldEditingDidBegin(with: viewType)
  }
}

  // MARK: - UIPickerViewDelegate

extension AddAlbumDateOptionView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectDay = dayOptionList[row]
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(describing: dayOptionList[row])
    }
}

    // MARK: - UIPickerViewDataSource

extension AddAlbumDateOptionView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dayOptionList.count
    }
}
