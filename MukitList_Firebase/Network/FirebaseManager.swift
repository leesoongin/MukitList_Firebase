//
//  Firebase.swift
//  MukitList_Firebase
//
//  Created by 이숭인 on 2021/02/15.
//

import UIKit
import Firebase

class FirebaseManager {
    static let shared = FirebaseManager()
    
    let db = Database.database().reference()

    //유저정보 저장
    func saveUserInfo(id : String, dict : [String:Any]){
        db.child("User").child(id).setValue(dict)
    }
    func loadUserInfo(id : String,completion : @escaping (User) -> (Void)){
        db.child("User").child(id).observeSingleEvent(of: .value) { snapshot in
            if !snapshot.hasChildren()  {
                //데이터가 없으면 해야할 행동
                print("don't have review data")
                return
            }
            do{
                let jsonData = try JSONSerialization.data(withJSONObject: snapshot.value!, options: [])
                let json = try JSONDecoder().decode(User.self, from: jsonData)
                
                completion(json)
            }catch let error{
                print("parsed error --> \(error.localizedDescription)")
            }
        }
    }
    //리뷰정보 저장
    func saveReviewsInfo(id : String){
        //인자로 review 구성 정보 받아와서 띄우기. !! 일단은 임시변수
        let review = Review(reviewPhoto: "https://i.esdrop.com/d/KPfCYxMNxg.png", title: "Title", writer: "writer", price: "20,000")
        
        guard let key = db.child("Review").child(id).childByAutoId().key else { return }
        let childUpdates = ["/Review/\(id)/\(key)": review.toDictionary]
        db.updateChildValues(childUpdates)
    }
    //리뷰정보 불러오기
    func loadReviewsInfo(id : String, completion : @escaping ([Review]) -> (Void)){
        db.child("Review").child(id).observeSingleEvent(of: .value) { snapshot in
            if !snapshot.hasChildren()  {
                //데이터가 없으면 해야할 행동
                print("don't have review data")
                completion([])
            }else{
                let dict = snapshot.value! as? [String:Any] ?? [:]
                var reviews = [Any]()
                
                for key in dict.keys {
                    reviews.append(dict[key]!)
                }
                print("arr -> \(reviews)")
                do{
                    let jsonData = try JSONSerialization.data(withJSONObject: reviews, options: [])
                    let json = try JSONDecoder().decode([Review].self, from: jsonData)
                    completion(json)
                }catch let error{
                    print("parsed error --> \(error.localizedDescription)")
                }
            }//else
        }//db
    }
    //먹킷리스트 저장
    func saveMukitList(id : String, document : Document){
        //id 문제 해결하고 와야할듯. , 업데이트를 배열형태로 하고싶은데 key value로밖에 안되는건가
        guard let key = db.child("MukitList").child(id).childByAutoId().key else { return }
        let childUpdates = ["/MukitList/\(id)/\(key)": document.toDictionary]
        db.updateChildValues(childUpdates)
        
    }
    //먹킷리스트 불러오기
    func loadMukitList(id : String, completion : @escaping ([Document])->(Void)){
        db.child("MukitList").child(id).observeSingleEvent(of: .value) { snapshot in
            if !snapshot.hasChildren()  {
                //데이터가 없으면 해야할 행동
                print("don't have review data")
                completion([])
            }
            let dict = snapshot.value! as? [String:Any] ?? [:]
            var mukitList = [Any]()
            
            for key in dict.keys {
                mukitList.append(dict[key]!)
            }
            do{
                let jsonData = try JSONSerialization.data(withJSONObject: mukitList, options: [])
                let json = try JSONDecoder().decode([Document].self, from: jsonData)
            }catch let error{
                print("parsed error --> \(error.localizedDescription)")
            }
        }
    }
}
