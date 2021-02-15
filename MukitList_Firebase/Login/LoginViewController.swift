//
//  LoginViewController.swift
//  MukitList_Firebase
//
//  Created by 이숭인 on 2021/02/12.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    let userViewModel = UserViewModel()
    let db = Database.database().reference()
    var nameStoragePath : String = ""
    var emailStoragePath : String = ""
    
    var id = ""
    var name = ""
    var email = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO : 임시 로그인 아이디 -> id, name, email
        self.id = "1"
        self.name = "soongmumu"
        self.email = "tnddls2ek@naver.com"
        
        nameStoragePath = "User/id/name"
        emailStoragePath = "User/id/email"
    }
    @IBAction func login(_ sender: Any) {
        //TODO : if is유저정보
        //TODO : false -> 디비에 저장, UserViewModel에 저장 -> 메인으로 화면이동
        //TODO : true -> userViewModel에 저장 -> 메인으로 화면이동
        db.child("User/id").observeSingleEvent(of: .value) { snapshot in
            let value = snapshot.value as? Dictionary<String,String>
            let name = value?["name"] ?? ""
            //TODO : viewModel에 저장
            //TODO : 화면이동
            if self.name == name {
                self.userViewModel.fetchUserInfo(id: self.id, name: self.name, email: self.email)
                self.moveToHome()
            }else{
                self.db.child(self.nameStoragePath).setValue(self.name)
                self.db.child(self.emailStoragePath).setValue(self.email)
                self.userViewModel.fetchUserInfo(id: self.id, name: self.name, email: self.email)
                self.moveToHome()
            }//else
        }//observe
    }//login
    
    func moveToHome(){
        let storyboard = UIStoryboard(name: "Master", bundle: nil)
        let vc = storyboard.instantiateInitialViewController()
        vc?.modalPresentationStyle = .fullScreen
        self.present(vc!, animated: false, completion: nil)
    }
}
