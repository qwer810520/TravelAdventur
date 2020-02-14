//
//  LoginViewController.swift
//  miniProject
//
//  Created by 楷岷 張 on 2017/4/6.
//  Copyright © 2017年 楷岷 張. All rights reserved.
//

import UIKit
import GoogleSignIn

class LoginViewController: ParentViewController {

  lazy private var backgroundView: LoginBackgroundView = {
    return LoginBackgroundView(delegate: self)
  }()

  private var presenter: LoginPresenter?

  override func viewDidLoad() {
    super.viewDidLoad()
    setUpPresenter()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setUserInterface()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.navigationBar.isHidden = false
  }

  // MARK: - Private Methods

  private func setUserInterface() {
    presenter?.checkUseAuthWithTouchID()

    navigationController?.navigationBar.isHidden = true
    view.addSubview(backgroundView)

    setUpLayout()
  }

  private func setUpPresenter() {
    presenter = LoginPresenter(delegate: self)
  }

  private func setUpLayout() {
    view.addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "H:|[view]|",
      options: [],
      metrics: nil,
      views: ["view": backgroundView]))
    view.addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "V:|[view]|",
      options: [],
      metrics: nil,
      views: ["view": backgroundView]))
  }
}

// MARK: - LoginDelegate

extension LoginViewController: LoginDelegate {
  func loginButtonDidPressed(type: LoginType) {
    switch type {
      case .facebook:
        presenter?.facebookLogin(with: self)
      case .google:
        presenter?.googleLogin()
    }
  }
}

// MARK: - LoginPresentDelegate

extension LoginViewController: LoginPresentDelegate {
  func googleSignBtnDidPressed() {
    GIDSignIn.sharedInstance().signIn()
  }

  func setUpGoogleSigninDelegate() {
    GIDSignIn.sharedInstance().delegate = self
    GIDSignIn.sharedInstance()?.presentingViewController = self
  }

  func presentAlert(with title: String, message: String?, checkAction: ((UIAlertAction) -> Void)?, cancelTitle: String?, cancelAction: ((UIAlertAction) -> Void)?) {
    showAlert(title: title, message: message, rightAction: checkAction, leftTitle: cancelTitle, leftAction: cancelAction)
  }

  func presentToMainVC() {
    present(TATabbarController(), animated: true, completion: nil)
  }

  func presentAlert(with title: String) {
    showAlert(title: title)
  }
}

  // MARK: - GIDSignInDelegate

extension LoginViewController: GIDSignInDelegate {
  func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
    presenter?.sign(signIn, didSignInFor: user, withError: error)
  }
}
