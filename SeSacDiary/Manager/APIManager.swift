//
//  APIManager.swift
//  SeSacDiary
//
//  Created by 신동희 on 2022/08/21.
//

import Foundation

import Alamofire
import SwiftyJSON

class APIManager {
    
    typealias CompletionHandler = (JSON) -> Void
    
    static let shared = APIManager()
    private init() {}
    
    
    func requestAPI(query: String, completionHandler: @escaping CompletionHandler) {
        
        let url = EndPoint.searchImageEndPoint
        
        let header: HTTPHeaders = ["Authorization": "Client-ID \(APIKeys.unsplashAccessKey)"]
        
        let parameter: Parameters = ["query" : query, "per_page": "30"]
        
        AF.request(url, method: .get, parameters: parameter, headers: header).validate(statusCode: 200...500).responseData { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)

                let statusCode = response.response?.statusCode ?? 500

                if 200..<300 ~= statusCode {
                    
                    completionHandler(json)
                    
                }else {
                    print("STATUSCODE : \(statusCode)")
                }
                
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
