//
//  UserMainViewController.swift
//  miniProject
//
//  Created by 楷岷 張 on 2018/8/28.
//  Copyright © 2018年 楷岷 張. All rights reserved.
//

import UIKit

class UserMainViewController: ParentViewController {

  lazy private var tableView: UITableView = {
    let view = UITableView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.delegate = self
    view.dataSource = self
    view.backgroundColor = .clear
    view.isScrollEnabled = false
    view.separatorStyle = .none
    view.tableFooterView = UIView(frame: .zero)
    view.register(with: [ShowProfileTableViewCell.self, BlankTableViewCell.self, SearchQRcodeOrTouchIDTableViewCell.self, SignOutTableViewCell.self])
    return view
  }()

  private var presenter: UserMainPresenter?

  override func viewDidLoad() {
    super.viewDidLoad()
    presenter = UserMainPresenter(delegate: self)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setUserInterface()
    presenter?.getUserProfile()
  }

  // MARK: - private Method

  private func setUserInterface() {
    setNavigation(title: "Profile", barButtonType: .none)
    view.addSubview(tableView)

    setUpLayout()
  }

  private func setUpLayout() {
    view.addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "H:|[tableView]|",
      options: [],
      metrics: nil,
      views: ["tableView": tableView]))

    view.addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "V:|[tableView]|",
      options: [],
      metrics: nil,
      views: ["tableView": tableView]))
  }
}

// MARK: - UITableViewDelegate

extension UserMainViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch indexPath.row {
      case 0:
        return 160
      case 1, 2, 3, 4:
        return 50
      default:
        return 0
    }
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    switch indexPath.row {
      case 1:
        let vc = TANavigationController(rootViewController: QRCodeTearderViewController())
        present(vc, animated: true, completion: nil)
      case 4: 
        presenter?.signOut()
      default:
        break
    }
  }
}

// MARK: - UITableViewDataSource

extension UserMainViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 5
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.row {
      case 0:
        let cell = tableView.dequeueReusableCell(with: ShowProfileTableViewCell.self, for: indexPath)
        cell.userModel = presenter?.getUserInfo()
        return cell
      case 1:
        let cell = tableView.dequeueReusableCell(with: SearchQRcodeOrTouchIDTableViewCell.self, for: indexPath)
        cell.cellType = .qrcode
        return cell
      case 2:
        let cell = tableView.dequeueReusableCell(with: SearchQRcodeOrTouchIDTableViewCell.self, for: indexPath)
        cell.cellType = .touchID
        cell.isOn = presenter?.getTouchIDStatus()
        cell.delegate = self
        return cell
      case 4:
        return tableView.dequeueReusableCell(with: SignOutTableViewCell.self, for: indexPath)
      default:
        return tableView.dequeueReusableCell(with: BlankTableViewCell.self, for: indexPath)
    }
  }
}

  // MARK: - searchQRcodeOrTouchIDCellDelegate

extension UserMainViewController: SearchQRcodeOrTouchIDCellDelegate {
  func touchIDSwitchValueChange(with status: Bool) {
    presenter?.setTouchIDSwitch(forStatus: status)
  }
}

  // MARK: - UserMainPresenterDelegate

extension UserMainViewController: UserMainPresenterDelegate {
  func dismissToLoginVC() {
    dismiss(animated: true)
  }

  func presentAlert(with title: String, message: String?, checkAction: ((UIAlertAction) -> Void)?, cancelTitle: String?, cancelAction: ((UIAlertAction) -> Void)?) {
    showAlert(title: title, message: message, rightAction: checkAction, leftTitle: cancelTitle, leftAction: cancelAction)
  }
}
