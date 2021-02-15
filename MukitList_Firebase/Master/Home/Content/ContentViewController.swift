//
//  ContentViewController.swift
//  MukitList_Firebase
//
//  Created by 이숭인 on 2021/02/15.
//

import UIKit

class ContentViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ContentViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reviewCell", for: indexPath) as? ReviewCell else {
            return UICollectionViewCell()
        }
        
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
