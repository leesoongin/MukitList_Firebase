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
}
