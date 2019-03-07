//
//  Constants.swift
//  TubiTest
//
//  Created by Denis Kalashnikov on 2/16/19.
//  Copyright © 2019 Denis Kalashnikov. All rights reserved.
//

import UIKit

class Constants {
    fileprivate static let API_KEY = "9TKPLAOK2YT8"
    fileprivate static let limit = 20
    fileprivate static let baseURL = "https://api.tenor.com/v1/"
    fileprivate static let defaultParams = "key=\(API_KEY)&media_filter=minimal&limit=\(limit)"
    
    
    static let searchURL = "\(Constants.baseURL)search?\(defaultParams)"
    static let trandingURL = "\(Constants.baseURL)trending?\(defaultParams)"

}
