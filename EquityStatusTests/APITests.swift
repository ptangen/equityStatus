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

        let testForEquityExpectation = expectation(description: "A pass here means an equity was retrieved and the equities array was created successfully.")

        APIClient.getEquitiesFromDB(mode: "t:GGG"){isSuccessful in
            XCTAssertTrue(isSuccessful)
            if isSuccessful {
                if let equity = self.store.equities.first {
                    XCTAssertNotNil(equity.ticker)
                    testForEquityExpectation.fulfill()
                } else {
                    XCTFail("Unable to retrieve the ticker from an equity in the datastore.")
                }
            } else {
                XCTFail("Unable to retrieve data from the server.")
            }
        }
        
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail("testForEquityExpectation waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    func testForEquityMetadata() {
        self.store.getEquitiesMetadataFromCoreData() // builds the equitiesMetadata if core data has data

        if self.store.equitiesMetadata.count == 0 {
            let testForEquityMetadataExpectation = expectation(description: "A pass here means data was retrieved, coredata was populated and the equitiesMetadata array was created successfully.")
            
             APIClient.getEquitiesMetadataFromDB() {isSuccessful in
                XCTAssertTrue(isSuccessful)
                if isSuccessful {
                    if let equityMetadata = self.store.equitiesMetadata.first {
                        if let ticker = equityMetadata.ticker {
                            XCTAssertNotNil(ticker)
                            testForEquityMetadataExpectation.fulfill()
                        }
                    }
                } else {
                    XCTFail("Unable to fetch equity metadata from the server.")
                }
            }
            waitForExpectations(timeout: 60) { error in
                if let error = error {
                    XCTFail("testForEquityMetadataExpectation waitForExpectationsWithTimeout errored: \(error)")
                }
            }
        } else {
            if let equityMetadata = self.store.equitiesMetadata.first {
                if let ticker = equityMetadata.ticker {
                    XCTAssertNotNil(ticker)
                }
            } else {
                XCTFail("The equityMetadata array exists, but unable to get a ticker from the object.")
            }
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
