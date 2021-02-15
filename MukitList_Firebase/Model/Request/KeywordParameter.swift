//
//  KeywordSearch.swift
//  MukitList_Firebase
//
//  Created by 이숭인 on 2021/02/14.
//

import UIKit

struct KeywordParameter {
    let query : String
    let x : String?
    let y : String?
    let radius : String?
    
    init(query : String){
        self.query = query
        self.x = nil
        self.y = nil
        self.radius = nil
    }
    
    init(query: String, x: String, y:String, radius: String){
        self.query = query
        self.x = x
        self.y = y
        self.radius = radius
    }
}
