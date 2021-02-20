//
//  LodingViewController.swift
//  MukitList_Firebase
//
//  Created by 이숭인 on 2021/02/15.
//

import UIKit
import KakaoSDKAuth
import KakaoSDKUser

class LodingViewController: UIViewController {
    let firebaseManager = FirebaseManager.shared
    let userViewModel = UserViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //view did appear한 이유 ?? view did load에서는 화면전환 하면 안되기때문 !!
    override func viewDidAppear(_ animated: Bool) {
        if AuthApi.hasToken(){
            saveUserInfo() // 유저정보 저장
            
            let storyboard = UIStoryboard(name: "Master", bundle: nil)
            let vc = storyboard.instantiateInitialViewController()
            vc?.modalPresentationStyle = .fullScreen
            self.present(vc!, animated: false, completion: nil)
            print("Master")
        }else{
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let vc = storyboard.instantiateInitialViewController()
            vc?.modalPresentationStyle = .fullScreen
            self.present(vc!, animated: false, completion: nil)
            print("login")
        }
        sleep(1)
    }
    
    func saveUserInfo(){
        UserApi.shared.me() {(user, error) in
            if let error = error {
                print(error)
            }
            else {
                self.firebaseManager.loadUserInfo(id: "\((user?.id)!)") { response in
                    self.userViewModel.fetchUserInfo(id: response.id, name: response.name, profileImage: response.profileImage)
                }
            }
        }
    }
}
