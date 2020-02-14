//
//  LoginPresenter.swift
//  miniProject
//
//  Created by Min on 2020/2/3.
//  Copyright © 2020 楷岷 張. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn
import FirebaseDatabase
import LocalAuthentication

protocol LoginPresentDelegate: BasePresenterDelegate {
  func presentToMainVC()
  func setUpGoogleSigninDelegate()
  func googleSignBtnDidPressed()
}

class LoginPresenter: NSObject {

  weak var delegate: LoginPresentDelegate? = nil
  private var isInLoginFlow = false

  init(delegate: LoginPresentDelegate? = nil) {
    self.delegate = delegate
    super.init()
    GIDSignIn.sharedInstance().clientID = GoogleToken.authClientID
    delegate?.setUpGoogleSigninDelegate()
  }

  // MARK: - API Methods

  func googleLogin() {
    UserDefaults.standard.set(false, forKey: UserDefaultsKey.loginSet.rawValue)
    delegate?.googleSignBtnDidPressed()
    isInLoginFlow = true
  }

  func facebookLogin(with viewController: ParentViewController) {
    isInLoginFlow = true
    UserDefaults.standard.set(true, forKey: UserDefaultsKey.loginSet.rawValue)
    LoginManager().logIn(permissions: ["email", "public_profile"], from: viewController) { [weak self] (_, error: Error?) in
      guard error == nil, let accessToken = AccessToken.current else {
        self?.isInLoginFlow = false
        return
      }
      UserDefaults.standard.set(accessToken.tokenString, forKey: UserDefaultsKey.FBTokenString.rawValue)
      let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
      self?.firebaseAuthSingin(credential: credential)
    }
  }

  private func firebaseAuthSingin(credential: AuthCredential) {
    delegate?.showIndicator()
    FirebaseManager.shared.signInForFirebase(credential: credential) { [weak self] result in
      switch result {
        case .success:
          self?.getUserProfile()
        case .failure:
          self?.delegate?.dismissIndicator()
          self?.isInLoginFlow = false
          self?.delegate?.presentAlert(with: "登入失敗", message: nil, checkAction: nil, cancelTitle: nil, cancelAction: nil)
      }
    }
  }

  private func getUserProfile() {
    FirebaseManager.shared.getUserProfile { [weak self] result in
      self?.isInLoginFlow = false
      self?.delegate?.dismissIndicator()
      switch result {
        case .success:
          self?.delegate?.presentToMainVC()
        case .failure(let error):
          self?.delegate?.presentAlert(with: error.localizedDescription, message: nil, checkAction: nil, cancelTitle: nil, cancelAction: nil)
      }
    }
  }

  func checkUseAuthWithTouchID() {
    guard UserDefaults.standard.bool(forKey: UserDefaultsKey.touchIDSwitch.rawValue) else { return }
    authenticateWithTouchID()
  }

  func sign(_ signIn: GIDSignIn?, didSignInFor user: GIDGoogleUser?, withError error: Error?) {
    guard error == nil, let user = user else {
      isInLoginFlow = false
      delegate?.presentAlert(with: error?.localizedDescription ?? "Something went Error", message: nil, checkAction: nil, cancelTitle: nil, cancelAction: nil)
      return
    }
    UserDefaults.standard.set(user.authentication.idToken, forKey: UserDefaultsKey.withIDToken.rawValue)
    UserDefaults.standard.set(user.authentication.accessToken, forKey: UserDefaultsKey.accessToken.rawValue)
    let credential = GoogleAuthProvider.credential(withIDToken: user.authentication.idToken, accessToken: user.authentication.accessToken)
    firebaseAuthSingin(credential: credential)
  }

  // MARK: - TouchID Method

  private func authenticateWithTouchID() {
    guard !isInLoginFlow else { return }
    let localAuthContent = LAContext()
    var error: NSError?
    guard localAuthContent.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) else {
      return
    }
    localAuthContent.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "請使用TouchID認證身份") { [weak self] (success, error) in
      switch success {
        case true:
          self?.delegate?.showIndicator()
          switch UserDefaults.standard.bool(forKey: UserDefaultsKey.loginSet.rawValue) {
            case true:
              let credential = FacebookAuthProvider.credential(withAccessToken: UserDefaults.standard.string(forKey: UserDefaultsKey.FBTokenString.rawValue) ?? "")
              self?.firebaseAuthSingin(credential: credential)
            case false:
              let credential = GoogleAuthProvider.credential(withIDToken: UserDefaults.standard.string(forKey: UserDefaultsKey.withIDToken.rawValue) ?? "", accessToken: UserDefaults.standard.string(forKey: UserDefaultsKey.accessToken.rawValue) ?? "")
              self?.firebaseAuthSingin(credential: credential)
        }
        case false:
          guard let error = error else { return }
          var errorMessage = ""
          switch error {
            case LAError.authenticationFailed:
              errorMessage = "驗證失敗是因為指紋結果不合"
            case LAError.passcodeNotSet:
              errorMessage = "驗證失敗是因為密碼沒有設置"
            case LAError.systemCancel:
              errorMessage = "系統取消驗證。譬如說在驗證期間，另外一個應用程式跑到前景"
            case LAError.userCancel:
              errorMessage = "使用者取消驗證(例如在對話框中按下取消按鈕)"
            case LAError.touchIDNotEnrolled:
              errorMessage = "使用者還沒有設置TouchID"
            case LAError.touchIDNotAvailable:
              errorMessage = "裝置上沒有TouchID"
            case LAError.userFallback:
              errorMessage = "使用者選擇用密碼驗證，而不是用 Touch ID。在驗證對話框中，有一個稱為 Enter Password 的按鈕。當使用者按下按鈕，這個 error 程式會回傳。"
            default:
              errorMessage = error.localizedDescription
          }
          OperationQueue.main.addOperation {
            self?.delegate?.presentAlert(with: errorMessage, message: nil, checkAction: nil, cancelTitle: nil, cancelAction: nil)
        }
      }
    }
  }
}
