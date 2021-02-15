//
//  KeyWordSearchViewModel.swift
//  MukitList_Firebase
//
//  Created by 이숭인 on 2021/02/14.
//

import UIKit
import Alamofire
import NMapsMap

// 네트워킹. 앱의 전반적인 키워드 검색은 이 뷰 모델을 이용할거기 때문에 싱글톤으로 사용

private let requestUrl : String = "https://dapi.kakao.com/v2/local/search/keyword.json?"
private let KAKAO_HEADER : String = "Authorization"
private let KAKAO_APP_KEY : String = "KakaoAK 5c71c9c97b66982a9d82ff3a6108f0ef"

class KeywordSearchViewModel {
    static let shared = KeywordSearchViewModel()
    
    var searchResults = [Document]()
    var nearbyRestaurantSearchResults = [Document]()
    var params = [String:String]()
    
    //키워드 검색 네트워킹 요청
    func searchKeyWord(completion : @escaping ([Document]) -> (Void)) {
        AF.request(requestUrl, method: .get, parameters: params, headers: [KAKAO_HEADER : KAKAO_APP_KEY]).validate(statusCode: 200..<300).responseJSON { response in
            switch response.result {
            case .success:
                do{
                    let jsonData = try JSONSerialization.data(withJSONObject: response.value!, options: .prettyPrinted)
                    let json = try JSONDecoder().decode(Documents.self, from: jsonData)
                    completion(json.documents)
                }catch let error {
                    print("parsing error -> \(error.localizedDescription)")
                }
            case .failure:
                print("fail")
            }
        }
    }
    //검색결과 response 업데이트
    func fetchSearchResults(results : [Document]){
        self.searchResults.removeAll()
        self.searchResults.append(contentsOf: results)
    }
    //내 주변찾기 결과 response 업데이트
    func fetchNearbyRestaurantSearchResults(results : [Document]){
        self.nearbyRestaurantSearchResults.removeAll()
        self.nearbyRestaurantSearchResults.append(contentsOf: results)
    }
    //parameter 정보 저장
    func fetchParams(parameter : KeywordParameter){
        self.params.removeAll()
        
        self.params["query"] = parameter.query
        if let x =  parameter.x{ self.params["x"] = x } else { return }
        if let y =  parameter.y{ self.params["y"] = y } else { return }
        if let radius =  parameter.radius{ self.params["radius"] = radius } else { return }
    }
    
}
