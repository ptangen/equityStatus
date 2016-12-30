//
//  Equity.swift
//  EquityStatus
//
//  Created by Paul Tangen on 12/29/16.
//  Copyright © 2016 Paul Tangen. All rights reserved.
//

import Foundation

class Equity {
    
    var ticker: String
    var name: String
    var tab: String
    var ROEaResult: Double
    var EPSiResult: Double
    var EPSvResult: Double
    var BViResult: Double
    var DRaResult: Double
    var SOrResult: Double
    var previousROIResult: Double
    var expectedROIResult: Double
    var ROEaStatus: String
    var EPSiStatus: String
    var EPSvStatus: String
    var BViStatus: String
    var DRaStatus: String
    var SOrStatus: String
    var previousROIStatus: String
    var expectedROIStatus: String
    var q1Answer: String
    var q2Answer: String
    var q3Answer: String
    var q4Answer: String
    var q5Answer: String
    var q6Answer: String
    var q1Status: String
    var q2Status: String
    var q3Status: String
    var q4Status: String
    var q5Status: String
    var q6Status: String
    
    // use this initializer for equities on the details tab
    init(ticker: String, name: String, tab: String, ROEaResult: Double, EPSiResult: Double, EPSvResult: Double, BViResult: Double, DRaResult: Double, SOrResult: Double, previousROIResult: Double, expectedROIResult: Double, ROEaStatus: String, EPSiStatus: String, EPSvStatus: String, BViStatus: String, DRaStatus: String, SOrStatus: String, previousROIStatus: String, expectedROIStatus: String, q1Answer: String, q2Answer: String, q3Answer: String, q4Answer: String, q5Answer: String, q6Answer: String, q1Status: String, q2Status: String, q3Status: String, q4Status: String, q5Status: String, q6Status: String) {
        self.ticker = ticker
        self.name = name
        self.tab = tab
        self.ROEaResult = ROEaResult
        self.EPSiResult = EPSiResult
        self.EPSvResult = EPSvResult
        self.BViResult = BViResult
        self.DRaResult = DRaResult
        self.SOrResult = SOrResult
        self.previousROIResult = previousROIResult
        self.expectedROIResult = expectedROIResult
        self.ROEaStatus = ROEaStatus
        self.EPSiStatus = EPSiStatus
        self.EPSvStatus = EPSvStatus
        self.BViStatus = BViStatus
        self.DRaStatus = DRaStatus
        self.SOrStatus = SOrStatus
        self.previousROIStatus = previousROIStatus
        self.expectedROIStatus = expectedROIStatus
        self.q1Answer = q1Answer
        self.q2Answer = q2Answer
        self.q3Answer = q3Answer
        self.q4Answer = q4Answer
        self.q5Answer = q5Answer
        self.q6Answer = q6Answer
        self.q1Status = q1Status
        self.q2Status = q2Status
        self.q3Status = q3Status
        self.q4Status = q4Status
        self.q5Status = q5Status
        self.q6Status = q6Status
    }
}
