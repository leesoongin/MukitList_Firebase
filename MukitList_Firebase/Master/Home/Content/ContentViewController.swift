//
//  ContentViewController.swift
//  MukitList_Firebase
//
//  Created by 이숭인 on 2021/02/15.
//

import UIKit
import Kingfisher
import NVActivityIndicatorView

class ContentViewController: UIViewController {
    let firebaseManager = FirebaseManager.shared
    let reviewViewModel = ReviewViewModel.shared
    let userViewModel = UserViewModel()
    let mukitListViewModel = MukitListViewModel.shared
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var placeNameLabel: UILabel!
    
    var document : Document!
    var indicator : NVActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(loadReviewsFromFirebase), name: NSNotification.Name("restaurantId"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(fetchDocument), name: NSNotification.Name("restaurantId"), object: nil)
        
        indicator = NVActivityIndicatorView(frame: CGRect(x: (collectionView.bounds.width/2)-50, y: 100, width: 50, height: 50),
                                            type: .squareSpin,
                                                color: .black,
                                                padding: 0)
        self.view.addSubview(indicator)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       print("appear --> 나타남")
        collectionView.reloadData()
    }

    @objc func loadReviewsFromFirebase(notification : NSNotification){
        //any type -> Document 형변환안하면 못쓴다 !!
        let document = (notification.userInfo!["document"])! as! Document
        indicator.startAnimating()
        firebaseManager.loadReviewsInfo(id: document.id) { response in
            self.reviewViewModel.fetchReviews(reviews: response)
            self.collectionView.reloadData()
            self.placeNameLabel.text = document.place_name
            self.indicator.stopAnimating()
        }
    }
    @objc func fetchDocument(notification : NSNotification){
        self.document = (notification.userInfo!["document"])! as? Document
    }
    
    @IBAction func saveMukitListToFirebase(_ sender: Any) {
        //먹킷리스트에 추가 하기 기능 추가
        firebaseManager.saveMukitList(id : userViewModel.user.id, document : self.document)
    }
    
    @IBAction func saveReviewToFirebase(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Upload", bundle: nil)
        let vc = storyboard.instantiateInitialViewController()
        vc?.modalPresentationStyle = .fullScreen
        self.present(vc!, animated: false, completion: nil)
        
        NotificationCenter.default.post(name: Notification.Name("placeId"), object: nil, userInfo: ["placeId":document.id])
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
