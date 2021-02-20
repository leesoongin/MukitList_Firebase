//
//  UploadViewController.swift
//  MukitList_Firebase
//
//  Created by 이숭인 on 2021/02/20.
//

import UIKit
//그냥 정보 받아서 파이어베이스 매니저를 통해 전송하기만 하면 된다.


class UploadViewController: UIViewController {
    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var priceLabel: UITextField!
    @IBOutlet weak var photoLabel: UITextField!
    
    let firebaseManager = FirebaseManager.shared
    let userViewModel = UserViewModel()
    let reviewViewModel = ReviewViewModel.shared
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
        let review = Review(reviewPhoto: "https://i.esdrop.com/d/KPfCYxMNxg.png", title: titleLabel.text!, writer: userViewModel.user.name, price: priceLabel.text!)
        
        firebaseManager.saveReviewsInfo(id: placeId , review: review) { response in
            self.firebaseManager.loadReviewsInfo(id: self.placeId) { response in
                self.reviewViewModel.fetchReviews(reviews: response)
                self.dismiss(animated: true, completion: nil)
            }
        } //save
    }//upload
}
