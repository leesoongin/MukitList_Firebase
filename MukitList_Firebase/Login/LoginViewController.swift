//
//  LoginViewController.swift
//  MukitList_Firebase
//
//  Created by 이숭인 on 2021/02/12.
//

import UIKit
import Firebase
import KakaoSDKAuth


class LoginViewController: UIViewController {
    let userViewModel = UserViewModel()
    let db = Database.database().reference()
    var nameStoragePath : String = ""
    var emailStoragePath : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameStoragePath = "User/id/name"
        emailStoragePath = "User/id/email"
    }
    @IBAction func login(_ sender: Any) {
        if (AuthApi.isKakaoTalkLoginAvailable()) {
            AuthApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    self.moveToHome()
                }
            }
        }
    } //login
    
    func moveToHome(){
        let storyboard = UIStoryboard(name: "Master", bundle: nil)
        let vc = storyboard.instantiateInitialViewController()
        vc?.modalPresentationStyle = .fullScreen
        self.present(vc!, animated: false, completion: nil)
    }
}

