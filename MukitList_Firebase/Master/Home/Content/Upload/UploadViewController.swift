//
//  UploadViewController.swift
//  MukitList_Firebase
//
//  Created by 이숭인 on 2021/02/20.
//

import UIKit
//그냥 정보 받아서 파이어베이스 매니저를 통해 전송하기만 하면 된다.


class UploadViewController: UIViewController {
    let firebaseManager = FirebaseManager.shared
    let userViewModel = UserViewModel()
    var placeId : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(fetchId), name: NSNotification.Name("placeId"), object: nil)

   }
    @objc func fetchId(notification : NSNotification){
        placeId = notification.userInfo!["placeId"] as? String
    }
    
    @IBAction func uploadCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func upload(_ sender: Any) {
        firebaseManager.saveReviewsInfo(id: placeId)
    }
}
