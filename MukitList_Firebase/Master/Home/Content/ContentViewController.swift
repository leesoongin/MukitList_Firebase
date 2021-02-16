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
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(loadReviews), name: NSNotification.Name("restaurantId"), object: nil)
    }
    //1. Firebase에서 해당하는 id에 있는 값들을 불러오기
    //2. reviewViewModel에 data fetch
    //3. collectionView에 뿌려주기
    @objc func loadReviews(notification : NSNotification){
        let id = "\((notification.userInfo!["id"])!)"
        firebaseManager.loadReviewsInfo(id: id) { response in
            self.reviewViewModel.fetchReviews(reviews: response)
            self.collectionView.reloadData()
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
