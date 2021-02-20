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
    
    func uploadReviewPhoto(id : String, data : Data?){
        print("data --> \(data), id --> \(id)")
        let reviewPhotoRef = storage.child("ReviewPhotos/\(id)").child("test")
        
        let uploadTask = reviewPhotoRef.putData(data!, metadata: nil) { (metadata, error) in
          guard let metadata = metadata else {
            
            return
          }
          let size = metadata.size
            reviewPhotoRef.downloadURL { (url, error) in
            guard let downloadURL = url else {
              // Uh-oh, an error occurred!
              return
            }
          }
        }
    }
}
