//
//  Review.swift
//  MukitList_Firebase
//
//  Created by 이숭인 on 2021/02/15.
//

//사진 제목 닉네임 가격대

import UIKit

struct Review : Codable{
    var reviewPhoto : String
    var title : String
    var writer : String
    var price : String
    
    var toDictionary : [String : Any] {
        let dict = [
            "title":self.title,
            "writer":self.writer,
            "reviewPhoto":self.reviewPhoto,
            "price":self.price,
        ]
        return dict
    }
    
    init(reviewPhoto : String, title : String, writer : String, price : String) {
        self.reviewPhoto = reviewPhoto
        self.title = title
        self.writer = writer
        self.price = price
    }
}
