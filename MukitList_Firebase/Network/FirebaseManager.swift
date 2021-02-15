//
//  Firebase.swift
//  MukitList_Firebase
//
//  Created by 이숭인 on 2021/02/15.
//

import UIKit
import Firebase

class FirebaseManager {
    let db = Database.database().reference()
    
    func saveUserInfo(id : String, dict : [String:Any]){
        db.child("User").child("id2:\((id))").setValue(dict)
    }
    
}
