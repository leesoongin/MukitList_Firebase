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
    
    func loadReviewsInfo(id : String, completion : @escaping ([Review]) -> (Void)){
        db.child("Review").child(id).observeSingleEvent(of: .value) { snapshot in
            do{
                let jsonData = try JSONSerialization.data(withJSONObject: snapshot.value!, options: [])
                let json = try JSONDecoder().decode([Review].self, from: jsonData)
                
                completion(json)
            }catch let error{
                print("parsed error --> \(error.localizedDescription)")
            }
        }//db
    }
}
