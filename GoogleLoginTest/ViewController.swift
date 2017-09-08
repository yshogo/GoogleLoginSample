//
//  ViewController.swift
//  GoogleLoginTest
//
//  Created by shogo.yamada on 2017/09/07.
//  Copyright © 2017年 shogo.yamada. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class ViewController: UIViewController,GIDSignInUIDelegate, GIDSignInDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
    }
    
    @IBAction func tapGoogleSingIn(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        
        if let error = error {
            print("Error: \(error.localizedDescription)")
            return
        }
        let authentication = user.authentication
        // Googleのトークンを渡し、Firebaseクレデンシャルを取得する。
        let credential = GoogleAuthProvider.credential(withIDToken: (authentication?.idToken)!,accessToken: (authentication?.accessToken)!)
        
        // Firebaseにログインする。
        Auth.auth().signIn(with: credential) { (user, error) in
            print("ログイン成功")
            //画面遷移処理
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("Sign off successfully")
    }


}

