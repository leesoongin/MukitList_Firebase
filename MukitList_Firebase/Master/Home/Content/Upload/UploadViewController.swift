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
    let firebaseStorageManager = FirebaseStorageManager.shared
    let userViewModel = UserViewModel()
    let reviewViewModel = ReviewViewModel.shared
    
    var placeId : String! // placeid
    let picker = UIImagePickerController()
    var photoData : Data?
    
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
    //1. TODO : photo upload to Firestorage
    //2. TODO : save review info to Firebase Database
    //3. TODO : load review info From Firebase Database
    @IBAction func upload(_ sender: Any) {
        firebaseStorageManager.uploadReviewPhoto(id: placeId, data: photoData){ url in
            let review = Review(reviewPhoto: "\(url)", title: self.titleLabel.text!, writer: self.userViewModel.user.name, price: self.priceLabel.text!)
                //사진 업로드 후 review정보 db에 저장
            self.firebaseManager.saveReviewsInfo(id: self.placeId , review: review) { response in
                //review 정보 저장 후 db에서 review정보 load
                self.firebaseManager.loadReviewsInfo(id: self.placeId) { response in
                    self.reviewViewModel.fetchReviews(reviews: response)
                    self.dismiss(animated: true, completion: nil)
                }
            } //save
        }
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
            imageView.image = image
            photoData = image.jpegData(compressionQuality: 0.8)
          }
        dismiss(animated: true, completion: nil)
    }
}
