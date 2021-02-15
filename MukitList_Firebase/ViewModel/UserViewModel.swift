//
//  UserViewModel.swift
//  MukitList_Firebase
//
//  Created by 이숭인 on 2021/02/08.
//

import UIKit

//어차피 유저정보는 어디서나 쓰일거니까 싱글톤으로 만들자
class UserManager{
    static let shared = UserManager()
    
    var user = User()
    
    func fetchUserInfo(id : String, name : String, profileImage : String){
        self.user.fetchParameters(id: id, name: name, profileImage: profileImage)
    }
    
}


class UserViewModel { static let shared = UserViewModel()
    private let manager = UserManager.shared
    
    var user : User {
        return manager.user
    }
    
    func fetchUserInfo(id: String, name : String, profileImage : String){
        return manager.fetchUserInfo(id: id, name: name, profileImage: profileImage)
    }
}
