//
//  ReviewViewModel.swift
//  MukitList_Firebase
//
//  Created by 이숭인 on 2021/02/15.
//

import UIKit
//

class ReviewViewModel {
    static let shared = ReviewViewModel()
    
    var reviews = [Review]() // db에서 받아온 리스트
    
    func fetchReviews(reviews : [Review]){
        self.reviews.removeAll()
        self.reviews.append(contentsOf: reviews)
    }
}
