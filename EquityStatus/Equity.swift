//
//  Equity.swift
//  EquityStatus
//
//  Created by Paul Tangen on 12/29/16.
//  Copyright © 2016 Paul Tangen. All rights reserved.
//

import Foundation

class Equity {
    
    let ticker: String
    let name: String
    var tab: EquityTabValue
    let ROEaResult: Double
    let EPSiResult: Double
    let EPSvResult: Double
    let BViResult: Double
    let DRaResult: Double
    let SOrResult: Double
    let previousROIResult: Double
    let expectedROIResult: Double
    
    var ROEHistory: ([String],[Double])
    var EPSHistory: ([String],[Double])
    var BVHistory: ([String],[Double])
    var DRHistory: ([String],[Double])
    var SOHistory: ([String],[Double])
    
    let ROEaStatus: String
    let EPSiStatus: String
    let EPSvStatus: String
    let BViStatus: String
    let DRaStatus: String
    let SOrStatus: String
    let previousROIStatus: String
    let expectedROIStatus: String
    
    var q1Answer: String
    var q2Answer: String
    var q3Answer: String
    var q4Answer: String
    var q5Answer: String
    var q6Answer: String
    
    var q1Status: String {
        didSet {
            oldValue != self.q1Status ? clearBuyEvalArrays() : ()
        }
    }
    var q2Status: String {
        didSet {
            oldValue != self.q2Status ? clearBuyEvalArrays() : ()
        }
    }
    var q3Status: String {
        didSet {
            oldValue != self.q3Status ? clearBuyEvalArrays() : ()
        }
    }
    var q4Status: String {
        didSet {
            oldValue != self.q4Status ? clearBuyEvalArrays() : ()
        }
    }
    var q5Status: String {
        didSet {
            oldValue != self.q5Status ? clearBuyEvalArrays() : ()
        }
    }

    var q6Status: String {
        didSet {
            oldValue != self.q6Status ? clearBuyEvalArrays() : ()
        }
    }

    
    // use this initializer for equities on the details tab
    init(ticker: String, name: String, tab: EquityTabValue,
         ROEaResult: Double, EPSiResult: Double, EPSvResult: Double, BViResult: Double, DRaResult: Double, SOrResult: Double,previousROIResult: Double, expectedROIResult: Double,
         
         ROEHistory: ([String],[Double]),EPSHistory: ([String],[Double]),BVHistory: ([String],[Double]), DRHistory: ([String],[Double]), SOHistory: ([String],[Double]),
         
         ROEaStatus: String, EPSiStatus: String, EPSvStatus: String, BViStatus: String, DRaStatus: String, SOrStatus: String, previousROIStatus: String, expectedROIStatus: String,
         q1Answer: String, q2Answer: String, q3Answer: String, q4Answer: String, q5Answer: String, q6Answer: String,
         q1Status: String, q2Status: String, q3Status: String, q4Status: String, q5Status: String, q6Status: String) {
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
        
        self.ROEHistory = ROEHistory
        self.EPSHistory = EPSHistory
        self.BVHistory = BVHistory
        self.DRHistory = DRHistory
        self.SOHistory = SOHistory
        
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

func clearBuyEvalArrays() {
    // empty these array as the list companies may be incorrect
    DataStore.sharedInstance.equitiesForBuyNames.removeAll()
    DataStore.sharedInstance.equitiesForEvaluation.removeAll()
}

enum EquityTabValue {
    case buy
    case evaluate
    case sell
    case notSet
}
