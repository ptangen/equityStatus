//
//  EquityStatusTests.swift
//  EquityStatusTests
//
//  Created by Paul Tangen on 12/18/16.
//  Copyright © 2016 Paul Tangen. All rights reserved.
//

import XCTest
@testable import EquityStatus

class EquityStatusTests: XCTestCase {
    
    let store = DataStore.sharedInstance
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testForEquity() {
        // This test should pass after the buy or evaluate tab is populated with one or more equities.
        // A pass here means data was retrieved and the equities array was created successfully.
        if let equity = store.equities.first {
            XCTAssertNotNil(equity.ticker)
        }
    }
    
    func testForEquityMetadata() {
        // This test should pass after the sell tab was opened and data was fetched.
        // A pass here means data was retrieved, coredata was populated and the equitiesMetadata array was created successfully.
        if let equityMetadata = store.equitiesMetadata.first {
            XCTAssertNotNil(equityMetadata.ticker)
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
