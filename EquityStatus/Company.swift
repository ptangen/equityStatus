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
    var tenYrsOld: Bool
    var eps_i: Int?
    var eps_sd: Double?
    var eps_last: Double?
    var roe_avg: Int?
    var bv_i: Int?
    var dr_avg: Int?
    var so_reduced: Int?
    var pe_avg: Double?
    var pe_change: Double?
    var price_last: Double?
    var previous_roi: Int?
    var expected_roi: Int?
    
    var q1_answer: String?
    var q2_answer: String?
    var q3_answer: String?
    var q4_answer: String?
    var q5_answer: String?
    var q6_answer: String?
    var own_answer: String?
    
    var q1_passed: Bool?
    var q2_passed: Bool?
    var q3_passed: Bool?
    var q4_passed: Bool?
    var q5_passed: Bool?
    var q6_passed: Bool?
    var own_passed: Bool?
    
    init(ticker: String, name:String, tenYrsOld:Bool) {
        self.ticker = ticker
        self.name = name
        self.tenYrsOld = tenYrsOld
    }
    
    subscript(key: String) -> Any? {
        switch key {
            case "name" : return name
            case "q1_passed" : return q1_passed
            default : return nil
        }
    }
        
    var eps_i_passed: Bool? {
        get {
            if let eps_iUnwrapped = eps_i {
                return Double(eps_iUnwrapped) >= Constants.thresholdValues.eps_i.rawValue
            }
            return nil
        }
    }
    
    var eps_sd_passed: Bool? {
        get {
            if let eps_sdUnwrapped = eps_sd {
                return eps_sdUnwrapped <= Double(Constants.thresholdValues.eps_sd.rawValue)
            }
            return nil
        }
    }
    
    var roe_avg_passed: Bool? {
        get {
            if let roe_avgUnwrapped = roe_avg {
                return Double(roe_avgUnwrapped) >= Constants.thresholdValues.roe_avg
            }
            return nil
        }
    }
    
    var bv_i_passed: Bool? {
        get {
            if let bv_iUnwrapped = bv_i {
                return Double(bv_iUnwrapped) >= Constants.thresholdValues.bv_i.rawValue
            }
            return nil
        }
    }
    
    var dr_avg_passed: Bool? {
        get {
            if let dr_avgUnwrapped = dr_avg {
                return Double(dr_avgUnwrapped) <= Constants.thresholdValues.dr_avg
            }
            return nil
        }
    }
    
    var so_reduced_passed: Bool? {
        get {
            if let so_reducedUnwrapped = so_reduced {
                return Double(so_reducedUnwrapped) >= Constants.thresholdValues.so_reduced.rawValue
            }
            return nil
        }
    }
    
    var pe_change_passed: Bool? {
        get {
            if let pe_changeUnwrapped = pe_change {
                return Double(pe_changeUnwrapped) <= Constants.thresholdValues.pe_change.rawValue
            }
            return nil
        }
    }
    
    var expected_roi_passed: Bool? {
        get {
            if let expected_roiUnwrapped = expected_roi {
                return Double(expected_roiUnwrapped) >= Constants.thresholdValues.expected_roi
            }
            return nil
        }
    }
    
    var previous_roi_passed: Bool? {
        get {
            if let previous_roiUnwrapped = previous_roi {
                return Double(previous_roiUnwrapped) >= Constants.thresholdValues.previous_roi
            }
            return nil
        }
    }
    
    var tab: Constants.EquityTabValue {
        get {
            var might_be_buy: Bool = false
            
            if let own_passedUnwrapped = own_passed {
                if own_passedUnwrapped {
                    return .own
                }
            }
            
            if let eps_i_passed_unwrapped = eps_i_passed, let eps_sd_passed_unwrapped = eps_sd_passed, let roe_avg_passed_unwrapped = roe_avg_passed, let dr_avg_passed_unwrapped = dr_avg_passed, let so_reduced_passed_unwrapped = so_reduced_passed, let pe_change_passed_unwrapped = pe_change_passed, let expected_roi_passed_unwrapped = expected_roi_passed, let previous_roi_passed_unwrapped = previous_roi_passed   {
                
                // if any of the calculated measures failed set to .sell
                if !eps_i_passed_unwrapped || !eps_sd_passed_unwrapped || !roe_avg_passed_unwrapped || !dr_avg_passed_unwrapped || !so_reduced_passed_unwrapped || !pe_change_passed_unwrapped || !expected_roi_passed_unwrapped || !previous_roi_passed_unwrapped  {
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
                    } else {
                        return .evaluate // one of the subjective measures is nil
                    }
                }
                
                // now we can assign buy or evaluate
                if might_be_buy {
                    return .buy
                }
            } else {
                return .sell // one of the financial measures was nil
            }
            return .sell
        }
    }
    

}

