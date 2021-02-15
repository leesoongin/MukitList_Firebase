//
//  User.swift
//  MukitList_Firebase
//
//  Created by 이숭인 on 2021/02/08.
//

import UIKit

// 로그인 한 유저 정보 저장.  - core data or realm 이 아니라서 매번 로그인해야하는 번거로움이 있음 ,,ㅠ
//일단 기능 부터 조지고 다 끝내고 core data , realm 조지기
struct User : Codable{
    var id : String
    var name : String
    var profileImage : String
    
    var toDictionary : [String:Any] {
        let dict : [String : Any] = ["id": id, "name":name, "profileImage":profileImage]
        return dict
    }
        
    mutating func fetchParameters(id : String, name : String, profileImage : String){
        self.id = id
        self.name = name
        self.profileImage = profileImage
    }
    
    init(){
        self.id = ""
        self.name = ""
        self.profileImage = ""
    }
}
