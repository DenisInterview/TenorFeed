//
//  VideoFeedModel.swift
//  TubiTest
//
//  Created by Denis Kalashnikov on 2/16/19.
//  Copyright © 2019 Denis Kalashnikov. All rights reserved.
//

import UIKit


class VideoFeedModel: NSObject {
    var next: String? = nil
    var videos = [VideoModel]()
    var isLoading = false
    var searchStr = ""
    
    func shouldLoadNextPage(_ currentItemIndex:Int) -> Bool {

        if(!isLoading && currentItemIndex > (videos.count-10)) {
            return true
        }else{
            return false
        }
    }
    
    func search(_ searchText:String, completion:@escaping ((Error?)->Void)) {
        isLoading = true
        searchStr = searchText
        next = nil
        NetworkManager.search(searchText, next: "0") { (tenorModel, error) in
            self.isLoading = false
            guard let tenorModel = tenorModel else{
                completion(error)
                return
            }
            self.next = tenorModel.next
            self.videos = tenorModel.results ?? []
            completion(nil)
        }
    }
    
    func loadPage(_ next:String?, completion:@escaping ((Error?)->Void)) {
        isLoading = true
        NetworkManager.search(searchStr, next: next) { (tenorModel, error) in
            self.isLoading = false
            guard let tenorModel = tenorModel else{
                completion(error)
                return
            }
            self.next = tenorModel.next
            self.videos.append(contentsOf: tenorModel.results ?? [])
            completion(nil)
        }
    }
    
    func loadNextPage(completion:@escaping ((Error?)->Void)) {
        if let nextVal = next, nextVal != "0" {
            loadPage(nextVal, completion: completion)
        }
    }
    
}
