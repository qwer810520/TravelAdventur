//
//  LoginViewController.swift
//  miniProject
//
//  Created by 楷岷 張 on 2017/4/6.
//  Copyright © 2017年 楷岷 張. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn
import FirebaseDatabase
import LocalAuthentication

class LoginViewController: ParentViewController {
    
    lazy private var backgroundView: LoginBackgroundView = {
        return LoginBackgroundView(delegate: self)
    }()
    
    private var selectLoginStatus = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("LoginViewController", #function)
        
        InstanceID.instanceID().instanceID { instanceIDResult, _ in
            print("instanceIDResult: \(instanceIDResult?.token)")
        }
        
        if !selectLoginStatus {
            if UserDefaults.standard.bool(forKey: "touchIDSwitch") {
                authenticateWithTouchID()
            }
        }
        //  google登入要加入以下步驟
        GIDSignIn.sharedInstance().clientID = "1085221770368-a3aejta4qgsqrip293u660mh0q9dhbas.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self

        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(backgroundView)
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

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - FB and Google SignIn API Method
    
    fileprivate func googleLogin() {
        guard isNetworkConnected() else { return }
        GIDSignIn.sharedInstance().signIn()
    }
    
    fileprivate func facebookLogin() {
        guard isNetworkConnected() else { return }
        LoginManager().logIn(permissions: ["email", "public_profile"], from: self) { [weak self] (_, error: Error?) in
            guard error == nil, let accessToken = AccessToken.current else {
                return
            }
            UserDefaults.standard.set(accessToken.tokenString, forKey: "FBTokenString")
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            self?.firebaseAuthSingin(credential: credential)
        }
    }
    
    private func firebaseAuthSingin(credential: AuthCredential) {
        startLoading()
        FirebaseManager.shared.signInForFirebase(credential: credential) { [weak self] (error) in
            guard error == nil else {
                self?.showAlert(type: .check, title: "Login Error")
                return
            }
            self?.getUserProfile()
        }
    }
    
    private func getUserProfile() {
        guard isNetworkConnected() else { return }
        FirebaseManager.shared.getUserProfile { [weak self] (error) in
            self?.stopLoading()
            guard error == nil else {
                self?.showAlert(type: .check, title: error?.localizedDescription ?? "")
                return
            }
            self?.present(TATabbarController(), animated: true, completion: nil)
        }
    }
    
    // MARK: - TouchID Method
    
    private func authenticateWithTouchID() {
        let localAuthContent = LAContext()
        var error: NSError?
        guard isNetworkConnected(), localAuthContent.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) else {
            return
        }
        localAuthContent.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "請使用TouchID認證身份") { [weak self] (success, error) in
            switch success {
            case true:
                self?.startLoading()
                switch UserDefaults.standard.bool(forKey: "loginSet") {
                case true:
                    let credential = FacebookAuthProvider.credential(withAccessToken: UserDefaults.standard.string(forKey: "FBTokenString") ?? "")
                    self?.firebaseAuthSingin(credential: credential)
                case false:
                    let credential = GoogleAuthProvider.credential(withIDToken: UserDefaults.standard.string(forKey: "withIDToken") ?? "", accessToken: UserDefaults.standard.string(forKey: "accessToken") ?? "")
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
                    self?.showAlert(type: .check, title: errorMessage)
                }
            }
        }
    }
}

    // MARK: - GIDSignInDelegate

extension LoginViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn, didSignInFor user: GIDGoogleUser, withError error: Error?) {
        guard error == nil else { return }
        UserDefaults.standard.set(user.authentication.idToken, forKey: "withIDToken")
        UserDefaults.standard.set(user.authentication.accessToken, forKey: "accessToken")
        let credential = GoogleAuthProvider.credential(withIDToken: user.authentication.idToken, accessToken: user.authentication.accessToken)
        firebaseAuthSingin(credential: credential)
    }
}

    // MARK: - LoginDelegate

extension LoginViewController: LoginDelegate {
    func loginButtonDidPressed(type: LoginType) {
        switch type {
        case .facebook:
            backgroundView.fbLoginButton.isEnabled = true
            selectLoginStatus = true
            UserDefaults.standard.set(true, forKey: "loginSet")
            facebookLogin()
        case .google:
            backgroundView.googleLoginButton.isEnabled = true
            selectLoginStatus = true
            UserDefaults.standard.set(false, forKey: "loginSet")
            googleLogin()
        }
    }
}
