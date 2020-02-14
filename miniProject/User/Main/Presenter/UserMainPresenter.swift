//
//  UserMainPresenter.swift
//  miniProject
//
//  Created by Min on 2020/2/14.
//  Copyright © 2020 楷岷 張. All rights reserved.
//

import Foundation
import FBSDKLoginKit
import GoogleSignIn
import FirebaseAuth
import Firebase

protocol UserMainPresenterDelegate: BasePresenterDelegate {
  func dismissToLoginVC()
}

class UserMainPresenter: NSObject {

  weak var delegate: UserMainPresenterDelegate?

  init(delegate: UserMainPresenterDelegate? = nil) {
    self.delegate = delegate
    super.init()
  }

  // MARK: - API Method

  func getUserInfo() -> LoginUserModel? {
    return FirebaseManager.shared.loginUserInfo
  }

  func getTouchIDStatus() -> Bool {
    return UserDefaults.standard.bool(forKey: UserDefaultsKey.touchIDSwitch.rawValue)
  }

  func setTouchIDSwitch(forStatus status: Bool) {
    UserDefaults.standard.set(status, forKey: UserDefaultsKey.touchIDSwitch.rawValue)
  }

  func getUserProfile() {
    FirebaseManager.shared.getUserProfile { [weak self] result in
      switch result {
        case .success:
          self?.delegate?.refreshUI()
        case .failure(let error):
          self?.delegate?.presentAlert(with: error.localizedDescription, message: nil, checkAction: nil, cancelTitle: nil, cancelAction: nil)
      }
    }
  }

  func signOut() {
    guard let providerData = Auth.auth().currentUser?.providerData else { return }
    let userInfo = providerData[0]
    switch userInfo.providerID {
      case "google.com":
        GIDSignIn.sharedInstance().signOut()
      case "facebook.com":
        LoginManager().logOut()
      default:
        break
    }
    do {
      try Auth.auth().signOut()
      delegate?.dismissToLoginVC()
    } catch {
      delegate?.presentAlert(with: error.localizedDescription, message: nil, checkAction: nil, cancelTitle: nil, cancelAction: nil)
    }
  }
}
