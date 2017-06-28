//
//  LoginViewController.swift
//  miniProject
//
//  Created by 楷岷 張 on 2017/4/6.
//  Copyright © 2017年 楷岷 張. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import GoogleSignIn
import FirebaseDatabase
import LocalAuthentication

class LoginViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    
    @IBAction func login(_ sender: UIButton) {
        UserDefaults.standard.set(true, forKey: "loginSet")
        facebookLogin()
    }
    
    @IBAction func googleLognInButton(_ sender: UIButton) {
        UserDefaults.standard.set(false, forKey: "loginSet")
        googleLogin()
    }
    
    func googleLogin() {
        if Library.isInternetOk() == true {
            GIDSignIn.sharedInstance().signIn()
        } else {
            present(Library.alertSet(title: "錯誤", message: "網路無法連線，請確認網路是否開啟", controllerType: .alert, checkButton1: "OK", checkButton1Type: .default, handler: nil), animated: true, completion: nil)
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if error != nil {
            return
        } else {
            UserDefaults.standard.set(user.authentication.idToken, forKey: "withIDToken")
            UserDefaults.standard.set(user.authentication.accessToken, forKey: "accessToken")
            let credential = GoogleAuthProvider.credential(withIDToken: user.authentication.idToken, accessToken: user.authentication.accessToken)
            firebaseAuthSingin(credential: credential)
        }
    }
    
    
    func facebookLogin() {
        if Library.isInternetOk() == true {
            let fbLoginManager = FBSDKLoginManager()
            fbLoginManager.logIn(withReadPermissions: ["email", "public_profile"], from: self) { (result:FBSDKLoginManagerLoginResult?, error:Error?) in
                if error != nil {
                    return
                }
                guard let accessToken = FBSDKAccessToken.current() else {
                    print("Failed to get access token")
                    return
                }
                UserDefaults.standard.set(accessToken.tokenString, forKey: "FBTokenString")
                let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
                self.firebaseAuthSingin(credential: credential)
            }
        } else {
            present(Library.alertSet(title: "錯誤", message: "網路無法連線，請確認網路是否開啟", controllerType: .alert, checkButton1: "OK", checkButton1Type: .default, handler: nil), animated: true, completion: nil)
        }
    }
    
    func authenticateWithTouchID() {
        let localAuthContent = LAContext()
        var authError:NSError?
        if Library.isInternetOk() == true {
            if localAuthContent.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
                localAuthContent.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: "請使用TouchID認證身份", reply: { (success, error) in
                    if success {
                        if UserDefaults.standard.bool(forKey: "loginSet") == true {
                            let credential = FacebookAuthProvider.credential(withAccessToken: UserDefaults.standard.string(forKey: "FBTokenString")!)
                            self.firebaseAuthSingin(credential: credential)
                        } else {
                            let credential = GoogleAuthProvider.credential(withIDToken: UserDefaults.standard.string(forKey: "withIDToken")!, accessToken: UserDefaults.standard.string(forKey: "accessToken")!)
                            self.firebaseAuthSingin(credential: credential)
                        }
                    } else {
                        if let error = error {
                            switch error {
                            case LAError.authenticationFailed:
                                OperationQueue.main.addOperation {
                                    self.present(Library.alertSet(title: "錯誤", message: "驗證失敗是因為指紋結果不合", controllerType: .alert, checkButton1: "OK", checkButton1Type: .default, handler: nil), animated: true, completion: nil)
                                    
                                }
                            case LAError.passcodeNotSet:
                                OperationQueue.main.addOperation {
                                    self.present(Library.alertSet(title: "錯誤", message: "驗證失敗是因為密碼沒有設置", controllerType: .alert, checkButton1: "OK", checkButton1Type: .default, handler: nil), animated: true, completion: nil)
                                    
                                }
                            case LAError.systemCancel:
                                OperationQueue.main.addOperation {
                                    self.present(Library.alertSet(title: "錯誤", message: "系統取消驗證。譬如說在驗證期間，另外一個應用程式跑到前景", controllerType: .alert, checkButton1: "OK", checkButton1Type: .default, handler: nil), animated: true, completion: nil)
                                    
                                }
                            case LAError.userCancel:
                                OperationQueue.main.addOperation {
                                    self.present( Library.alertSet(title: "錯誤", message: "使用者取消驗證(例如在對話框中按下取消按鈕)", controllerType: .alert, checkButton1: "OK", checkButton1Type: .default, handler: nil), animated: true, completion: nil)
                                    
                                }
                            case LAError.touchIDNotEnrolled:
                                OperationQueue.main.addOperation {
                                    self.present( Library.alertSet(title: "錯誤", message: "使用者還沒有設置TouchID", controllerType: .alert, checkButton1: "OK", checkButton1Type: .default, handler: nil), animated: true, completion: nil)
                                    
                                }
                            case LAError.touchIDNotAvailable:
                                OperationQueue.main.addOperation {
                                    self.present(Library.alertSet(title: "錯誤", message: "裝置上沒有TouchID", controllerType: .alert, checkButton1: "OK", checkButton1Type: .default, handler: nil), animated: true, completion: nil)
                                    
                                }
                            case LAError.userFallback:
                                OperationQueue.main.addOperation {
                                    self.present(Library.alertSet(title: "錯誤", message: "使用者選擇用密碼驗證，而不是用 Touch ID。在驗證對話框中，有一個稱為 Enter Password 的按鈕。當使用者按下按鈕，這個 error 程式會回傳。", controllerType: .alert, checkButton1: "OK", checkButton1Type: .default, handler: nil), animated: true, completion: nil)
                                    
                                }
                            default:
                                OperationQueue.main.addOperation {
                                    self.present(Library.alertSet(title: "錯誤", message: error.localizedDescription, controllerType: .alert, checkButton1: "OK", checkButton1Type: .default, handler: nil), animated: true, completion: nil)
                                    
                                }
                            }
                        }
                    }
                })
            }
        } else {
            present(Library.alertSet(title: "錯誤", message: "網路無法連線，請確認網路是否開啟", controllerType: .alert, checkButton1: "OK", checkButton1Type: .default, handler: nil), animated: true, completion: nil)
        }
    }

    
    
    func firebaseAuthSingin(credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil {
                let alertController = UIAlertController(title: "Login Error", message: error?.localizedDescription, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
            } else {
                guard let userPhotoURL = user?.photoURL?.absoluteString, let userName = user?.displayName else {
                    return
                }
                FirebaseServer.firebase().takeUserData(name: userName, userPhoto: userPhotoURL, completion: { 
                    self.performSegue(withIdentifier: "inside", sender: nil)
                })
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.bool(forKey: "touchIDSwitch") == true {
            authenticateWithTouchID()
        }
//        google登入要加入以下步驟
        GIDSignIn.sharedInstance().clientID = "1085221770368-a3aejta4qgsqrip293u660mh0q9dhbas.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
    }
}
