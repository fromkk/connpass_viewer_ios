//
//  NSDateExtensionTest.swift
//  ConnpassViewer
//
//  Created by Kazuya Ueoka on 2016/05/15.
//  Copyright © 2016年 fromKK. All rights reserved.
//

import XCTest

class NSDateExtensionTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        let test: String = "2016-02-29 10:00:00"
        guard let date: NSDate = test.dateFromFormat("yyyy-MM-dd HH:mm:ss") else
        {
            return
        }
        XCTAssert(date.stringWithFormat("yyyy-MM-dd HH:mm:ss") == test, "date")
        
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
