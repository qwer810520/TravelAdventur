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

class LoginViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    
    @IBAction func login(_ sender: UIButton) {
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
                let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
                self.firebaseAuthSingin(credential: credential)
            }
        } else {
            present(Library.alertSet(title: "錯誤", message: "網路無法連線，請確認網路是否開啟", controllerType: .alert, checkButton1: "OK", checkButton1Type: .default, handler: nil), animated: true, completion: nil)
        }
    }
    
    @IBAction func googleLognInButton(_ sender: UIButton) {
        if Library.isInternetOk() == true {
            GIDSignIn.sharedInstance().signIn()
        } else {
           present(Library.alertSet(title: "錯誤", message: "網路無法連線，請確認網路是否開啟", controllerType: .alert, checkButton1: "OK", checkButton1Type: .default, handler: nil), animated: true, completion: nil)
        }
        
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        let credential = GoogleAuthProvider.credential(withIDToken: user.authentication.idToken, accessToken: user.authentication.accessToken)
        firebaseAuthSingin(credential: credential)
    }
    
    func firebaseAuthSingin(credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil {
                let alertController = UIAlertController(title: "Login Error", message: error?.localizedDescription, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
            } else {
                self.performSegue(withIdentifier: "inside", sender: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        google登入要加入以下步驟
        GIDSignIn.sharedInstance().clientID = "1085221770368-a3aejta4qgsqrip293u660mh0q9dhbas.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
    }
}
