//
//  LoginViewController.swift
//  MukitList_Firebase
//
//  Created by 이숭인 on 2021/02/12.
//

import UIKit
import Firebase
import KakaoSDKAuth
import KakaoSDKUser
//Kakao UserApi를 이용, 사용자 정보 불러와 정의된 유저모델에 저장

class LoginViewController: UIViewController {
    let userViewModel = UserViewModel()
    let firebaseManager = FirebaseManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func login(_ sender: Any) {
        if (AuthApi.isKakaoTalkLoginAvailable()) {
            AuthApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    self.saveUserInfo()
                    self.moveToHome()
                }
            }
        }
    } //login
    //유저정보 저장
    func saveUserInfo(){
        UserApi.shared.me() {(user, error) in
            if let error = error {
                print(error)
            }
            else {
                self.userViewModel.fetchUserInfo(id: "\((user?.id)!)", name: (user?.kakaoAccount?.profile?.nickname)!, profileImage: "\((user?.kakaoAccount?.profile?.profileImageUrl)!)")
                DispatchQueue.main.async {
                    self.firebaseManager.saveUserInfo(id: self.userViewModel.user.id, dict: self.userViewModel.user.toDictionary)
                }
            }
        }
    }
    
    func moveToHome(){
        let storyboard = UIStoryboard(name: "Master", bundle: nil)
        let vc = storyboard.instantiateInitialViewController()
        vc?.modalPresentationStyle = .fullScreen
        self.present(vc!, animated: false, completion: nil)
    }
}

