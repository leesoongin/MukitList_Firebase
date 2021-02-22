//
//  FirebaseStorageManager.swift
//  MukitList_Firebase
//
//  Created by 이숭인 on 2021/02/20.
//

import UIKit
import Firebase

class FirebaseStorageManager {
    static let shared = FirebaseStorageManager()
    
    let storage = Storage.storage().reference()
    
    //id -> place id
    func uploadReviewPhoto(id : String, data : Data?,completion : @escaping (URL)->(Void)){
        let reviewPhotoRef = storage.child("ReviewPhotos/\(id)").child("test3")
        let uploadTask = reviewPhotoRef.putData(data!, metadata: nil) { (metadata, error) in
        }
        reviewPhotoRef.downloadURL { (url, error) in
            guard let downloadUrl = url else {
                print("error -->  \(String(describing: error?.localizedDescription))")
                return
            }
            uploadTask.observe(.success) { snapshot in
                print("success !!")
                completion(downloadUrl)
            }
        }
        uploadTask.observe(.progress) { snapshot in
            let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
                / Double(snapshot.progress!.totalUnitCount)
            print("percent --> \(percentComplete)")
        }
        
    }
}
