//
//  LodingViewController.swift
//  MukitList_Firebase
//
//  Created by 이숭인 on 2021/02/15.
//

import UIKit
import KakaoSDKAuth

class LodingViewController: UIViewController {
    let firebaseManager = FirebaseManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //view did appear한 이유 ?? view did load에서는 화면전환 하면 안되기때문 !!
    override func viewDidAppear(_ animated: Bool) {
        if AuthApi.hasToken(){
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
}
