//
//  Company.swift
//  EquityStatus
//
//  Created by Paul Tangen on 11/16/19.
//  Copyright © 2019 Paul Tangen. All rights reserved.
//

import Foundation

class Company {
    var ticker: String
    var name: String
    var eps_i: Int?
    var eps_sd: Double?
    var eps_last: Double?
    var roe_avg: Int?
    var bv_i: Int?
    var dr_avg: Int?
    var so_reduced: Int?
    var pe_avg: Double?
    var price_last: Double?
    var previous_roi: Int?
    var expected_roi: Int?
    
    var q1_answer: String?
    var q2_answer: String?
    var q3_answer: String?
    var q4_answer: String?
    var q5_answer: String?
    var q6_answer: String?
    
    var q1_passed: Bool?
    var q2_passed: Bool?
    var q3_passed: Bool?
    var q4_passed: Bool?
    var q5_passed: Bool?
    var q6_passed: Bool?
    
    init(ticker: String, name:String) {
        self.ticker = ticker
        self.name = name
    }
        
    var eps_i_passed: Bool {
        get {
            if let eps_iUnwrapped = eps_i {
                return eps_iUnwrapped >= Constants.thresholdValues.eps_i.rawValue
            } else {
                return false
            }
        }
    }
    
    var eps_sd_passed: Bool {
        get {
            if let eps_sdUnwrapped = eps_sd {
                return eps_sdUnwrapped <= Double(Constants.thresholdValues.eps_sd.rawValue)
            } else {
                return false
            }
        }
    }
    
    var roe_avg_passed: Bool {
        get {
            if let roe_avgUnwrapped = roe_avg {
                return roe_avgUnwrapped >= Constants.thresholdValues.roe_avg.rawValue
            } else {
                return false
            }
        }
    }
    
    var bv_i_passed: Bool {
        get {
            if let bv_iUnwrapped = bv_i {
                return bv_iUnwrapped >= Constants.thresholdValues.bv_i.rawValue
            } else {
                return false
            }
        }
    }
    
    var dr_avg_passed: Bool {
        get {
            if let dr_avgUnwrapped = dr_avg {
                return dr_avgUnwrapped <= Constants.thresholdValues.dr_avg
            } else {
                return false
            }
        }
    }
    
    var so_reduced_passed: Bool {
        get {
            if let so_reducedUnwrapped = so_reduced {
                return so_reducedUnwrapped >= Constants.thresholdValues.so_reduced.rawValue
            } else {
                return false
            }
        }
    }
    
    var expected_roi_passed: Bool {
        get {
            if let expected_roiUnwrapped = expected_roi {
                return expected_roiUnwrapped >= Constants.thresholdValues.expected_roi
            } else {
                return false
            }
        }
    }
    
    var previous_roi_passed: Bool {
        get {
            if let previous_roiUnwrapped = previous_roi {
                return previous_roiUnwrapped >= Constants.thresholdValues.previous_roi
            } else {
                return false
            }
        }
    }
    
    var tab: EquityTabValue {
        get {
            var might_be_buy: Bool = false
            
            // if any of the calculated measures failed set to .sell
            if !eps_i_passed || !eps_sd_passed || !roe_avg_passed || !dr_avg_passed || !so_reduced_passed || !expected_roi_passed || !previous_roi_passed  {
                return .sell }
            
            // the remaining companies are can be:
            // .sell if any of the subjective measures failed
            // .evaluate if any of the objective measures are nill
            // .buy if all the objective measures are true
            
            let questionProperties = [q1_passed, q2_passed, q3_passed, q4_passed, q5_passed, q6_passed]
            for questionProperty in questionProperties {
                if let questionProperty_unwrapped = questionProperty {
                   if questionProperty_unwrapped {
                       might_be_buy = true
                   } else {
                       return .sell // property is false
                   }
                }
            }
            
            // now we can assign buy or evaluate
            if might_be_buy {
                return .buy
            } else {
                return .evaluate // the company is niether buy or sell so it is evaluate
            }
        }
    }
}

