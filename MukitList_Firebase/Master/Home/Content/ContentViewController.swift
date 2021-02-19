//
//  ContentViewController.swift
//  MukitList_Firebase
//
//  Created by 이숭인 on 2021/02/15.
//

import UIKit
import Kingfisher

class ContentViewController: UIViewController {
    let firebaseManager = FirebaseManager()
    let reviewViewModel = ReviewViewModel()
    let userViewModel = UserViewModel()
    let mukitListViewModel = MukitListViewModel.shared
    
    @IBOutlet weak var collectionView: UICollectionView!

    var document : Document!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(loadReviewsFromFirebase), name: NSNotification.Name("restaurantId"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(fetchDocument), name: NSNotification.Name("restaurantId"), object: nil)
    }
    //1. Firebase에서 해당하는 id에 있는 값들을 불러오기
    //2. reviewViewModel에 data fetch
    //3. collectionView에 뿌려주기
    @objc func loadReviewsFromFirebase(notification : NSNotification){
        //any type -> Document 형변환안하면 못쓴다 !!
        let document = (notification.userInfo!["document"])! as! Document
    
        firebaseManager.loadReviewsInfo(id: document.id) { response in
            self.reviewViewModel.fetchReviews(reviews: response)
            self.collectionView.reloadData()
        }
    }
    
    @objc func fetchDocument(notification : NSNotification){
        self.document = (notification.userInfo!["document"])! as? Document
    }
    
    @IBAction func saveMukitListToFirebase(_ sender: Any) {
        //먹킷리스트에 추가 하기 기능 추가
        firebaseManager.saveMukitList(id : userViewModel.user.id, document : self.document)
        firebaseManager.loadMukitList(id: userViewModel.user.id) { response in
            //받아온 데이터 MukitListViewModel에 저장하고 화면에 뿌리기
        }
    }
    
}

extension ContentViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reviewViewModel.reviews.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reviewCell", for: indexPath) as? ReviewCell else {
            return UICollectionViewCell()
        }
        
        
        //리펙토링할때 프로토콜 상속으로 코드 중복 줄여보자.. 
        let url = URL(string: reviewViewModel.reviews[indexPath.row].reviewPhoto)!
        cell.imageView.kf.setImage(with: url)
        cell.titleLabel.text = reviewViewModel.reviews[indexPath.row].title
        cell.writerLabel.text = reviewViewModel.reviews[indexPath.row].writer
        cell.priceLabel.text = reviewViewModel.reviews[indexPath.row].price
        
        cell.backgroundColor =  #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        cell.layer.cornerRadius = 10.0
        cell.layer.masksToBounds = true
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0.3, height: 1.0)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 0.4
        cell.layer.masksToBounds = false
        
        return cell
    }
}

extension ContentViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension ContentViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let margin : CGFloat = 16
        let width = collectionView.bounds.width - (margin * 2)
        let height = width * (2/3)
        
        print("cell width --> \(width), height --> \(height)")
        return CGSize(width: width, height: height)
    }
}
