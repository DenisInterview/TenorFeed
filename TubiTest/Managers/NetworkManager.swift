//
//  NetworkManager.swift
//  TubiTest
//
//  Created by Denis Kalashnikov on 2/16/19.
//  Copyright © 2019 Denis Kalashnikov. All rights reserved.
//

import UIKit
import Alamofire


enum NetworkError: Error {
    case network
    case unknown
}

class NetworkManager: NSObject {
    static let shared = NetworkManager()

    static func search(_ searchText:String, next: String?, completion:@escaping ((VideoTenorModel?, Error?)->Void)) {
        let nextStr = (next != "0") ? "&pos=\(next!)" : "" 
        var searchUrl = "\(Constants.searchURL)&q=\(searchText)"
        
        if searchText.isEmpty {
            searchUrl = Constants.trandingURL
        }
        if let url = URL(string: "\(searchUrl)\(nextStr)")
        {
            Alamofire.request(url).responseVideoModel { response in
                if let model = response.result.value {
                    print("next \(String(describing: model.next))")
                    completion(model, nil)
                }else if response.error != nil{
                    completion(nil, response.error)
                }else{
                    completion(nil, NetworkError.unknown)
                }
            }
        }else{
            completion(nil, NetworkError.unknown)
        }
    }
}
