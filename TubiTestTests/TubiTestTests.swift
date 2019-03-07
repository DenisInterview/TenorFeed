//
//  TubiTestTests.swift
//  TubiTestTests
//
//  Created by Denis Kalashnikov on 2/16/19.
//  Copyright © 2019 Denis Kalashnikov. All rights reserved.
//

import XCTest
@testable import TubiTest

class TubiTestTests: XCTestCase {
    var model: VideoTenorModel?
    override func setUp() {
        if let url = Bundle.main.url(forResource: "testData", withExtension: "json"), let jsonData = try? Data(contentsOf: url){
           
            let decoder = JSONDecoder()
            model = try? decoder.decode(VideoTenorModel.self, from: jsonData)
        }
       
    }

    override func tearDown() {
        model = nil
    }

    func testModelHasLoaded() {
        XCTAssert(model != nil)
    }
    
    func testNumbersOfVideoLoaded()  {
        XCTAssert(model?.results?.count ?? -1 > 0)
    }

}
