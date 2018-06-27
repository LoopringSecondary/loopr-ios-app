//
//  H5DexDataManagerTests.swift
//  loopr-iosTests
//
//  Created by 王忱 on 2018/6/27.
//  Copyright © 2018年 Loopring. All rights reserved.
//

import XCTest
@testable import loopr_ios

class H5DexDataManagerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func test() {
        let json = JSON("0x7acbff6790c56d332cc002ea6e0c3f73fce8f927947709986ab993b234c78416")
        H5DexDataManager.shared.signMessage(json)
    }
    
}
