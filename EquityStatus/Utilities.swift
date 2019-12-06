//
//  Utilities.swift
//  EquityStatus
//
//  Created by Paul Tangen on 12/19/16.
//  Copyright © 2016 Paul Tangen. All rights reserved.
//

import Foundation
import UIKit

class Utilities {

    // The api return status values such as pass, fail, noData, 100, 101 and 200. Convert these values to unicode value of the font icon.
    
    class func getStatusIcon(status: Bool?, uiLabel: UILabel) {
        if let statusUnwrapped = status {
            if statusUnwrapped {
                uiLabel.text = Constants.iconLibrary.faCheckCircle.rawValue // passed
                uiLabel.textColor = UIColor(named: .statusGreen)
            } else {
                uiLabel.text = Constants.iconLibrary.faTimesCircle.rawValue // failed
                uiLabel.textColor = UIColor(named: .statusRed)
            }
        } else {
            uiLabel.text = Constants.iconLibrary.faCircleO.rawValue // missing
            uiLabel.textColor = UIColor(named: .disabledText)
        }
    }
    
//    class func populateMeasureInfo(){
//        let store = DataStore.sharedInstance
//        store.measureInfoArr.append(Measure(name: "eps_i", longName: "Earnings Per Share Growth Rate"))
//    }
    
    class func getMeasureLongName(measure: String) -> String {
            switch measure {
            case "roe_avg":
                return "Avg Return on Equity"
            case "eps_i":
                return "Earnings Per Share Growth Rate"
            case "eps_sd":
                return "Earnings Per Share Volatility"
            case "bv_i":
                return "Book Value Growth Rate"
            case "dr_avg":
                return "Avg Debt Ratio"
            case "so_reduced":
                return "Shares Outstanding Reduced"
            case "previous_roi":
                return "Previous Return on Investment"
            case "expected_roi":
                return "Expected Return on Investment"
            case "q1":
                return "Is there a strong upward trend in the EPS?"
            case "q2":
                return "Do you understand the product/service?"
            case "q3":
                return "Has the product/service been consistent for 10 years?"
            case "q4":
                return "Does the company invest in it's area of expertise?"
            case "q5":
                return "Are few expenditures required to maintain operations?"
            case "q6":
                return "Is the company free to adjust prices with inflation?"
            default:
                return ""
            }
    }
    
    class func showAlertMessage(_ message: String, viewControllerInst: UIViewController) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default,handler: nil))
        viewControllerInst.present(alertController, animated: true, completion: nil)
    }
}
