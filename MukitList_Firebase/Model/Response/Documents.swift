//
//  Documents.swift
//  MukitList_Firebase
//
//  Created by 이숭인 on 2021/02/14.
//

import UIKit

struct Documents : Codable{
    let documents : [Document]
}

struct Document : Codable {
    let place_name : String
    let address_name : String
    let category_group_name : String
    let category_group_code : String
    let id : String
    let x : String
    let y : String
    
    var toDictionary : [String : Any]{
        let dict : [String: Any] = ["place_name":place_name, "address_name":address_name, "category_group_name":category_group_name, "category_group_code":category_group_code, "id":id, "x":x, "y":y]
        return dict
    }
}
