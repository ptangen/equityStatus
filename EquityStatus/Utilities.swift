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
    class func setStatusIcon(status: String, uiLabel: UILabel) {
        if status == "pass" || status == "101" {
            uiLabel.text = Constants.iconLibrary.faCheckCircle.rawValue
            uiLabel.textColor = UIColor(named: .statusGreen)
        } else if status == "fail" || status == "100" {
            uiLabel.text = Constants.iconLibrary.faTimesCircle.rawValue
            uiLabel.textColor = UIColor(named: .statusRed)
        } else if status == "noData" {
            uiLabel.text = Constants.iconLibrary.faCircleO.rawValue
            uiLabel.textColor = UIColor(named: .disabledText)
        } else {
            uiLabel.text = Constants.iconLibrary.faCircleO.rawValue
            uiLabel.textColor = UIColor(named: .statusGreen)
        }
    }
    
    class func getTickerFromLabel(fullString: String) -> String {
        // function used to extract the ticker symbol
        let chars = fullString.characters;
        
        // Get character indexes.
        if let indexLeftParen = chars.index(of: "("), let indexRightParen = chars.index(of: ")") {
            // Get before and after indexes.
            let indexAfterLeftParen = chars.index(after: indexLeftParen)
            let indexBeforeRightParen = chars.index(before: indexRightParen)
            return fullString[indexAfterLeftParen...indexBeforeRightParen]
        }
        return "" // should never be used
    }
    
    class func showAlertMessage(_ message: String, viewControllerInst: UIViewController) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
        viewControllerInst.present(alertController, animated: true, completion: nil)
    }
    
    class func getSellTabCount() -> String {
        let store = DataStore.sharedInstance
        // get the count of equityMetadata items where showInSellTab == true and then show that value in the sell tab
        let equityMetadataForSellTab = store.equitiesMetadata.filter({(item: EquityMetadata) -> Bool in
            return item.showInSellTab
        })
        return String(equityMetadataForSellTab.count)
    }
}
