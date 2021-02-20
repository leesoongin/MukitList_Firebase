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
    @IBOutlet weak var imageView: UIImageView!
    
    let firebaseManager = FirebaseManager.shared
    let userViewModel = UserViewModel()
    let reviewViewModel = ReviewViewModel.shared
    
    var placeId : String!
    let picker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(fetchId), name: NSNotification.Name("placeId"), object: nil)
        
   }
    @objc func fetchId(notification : NSNotification){
        placeId = notification.userInfo!["placeId"] as? String
    }
    
    @IBAction func addPhoto(_ sender: Any) {
        let alert =  UIAlertController(title: "원하는 타이틀", message: "원하는 메세지", preferredStyle: .actionSheet)
        let library =  UIAlertAction(title: "사진앨범", style: .default) { (action) in self.openLibrary()
        }
        let camera =  UIAlertAction(title: "카메라", style: .default) { (action) in
        self.openCamera()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(library)
        alert.addAction(camera)
        alert.addAction(cancel)

        present(alert, animated: true, completion: nil)
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
    
    func openLibrary(){
        picker.sourceType = .photoLibrary
        
        present(picker, animated: false, completion: nil)
    }

    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            picker.sourceType = .camera
            present(picker, animated: false, completion: nil)
        }else{
            print("Camera not available")
        }
    }
}

extension UploadViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            print("image -- > \(image)")
            imageView.image = image
        }
        print("info --> \(info)")
        dismiss(animated: true, completion: nil)
    }
    
}
