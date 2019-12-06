//
//  Constants.swift
//  EquityStatus
//
//  Created by Paul Tangen on 12/18/16.
//  Copyright © 2016 Paul Tangen. All rights reserved.
//


import Foundation
import UIKit

struct Constants{
    
    enum fontSize: CGFloat {
        case xxsmall =      12
        case xsmall =       14
        case small =        16
        case medium =       18
        case large =        24
        case xlarge =       36
        case xxlarge =      48
    }
    
    enum iconLibrary: String {
        case menu =             "\u{E5D2}"
        case faCheckCircle =    "\u{f058}"
        case faTimesCircle =    "\u{f057}"
        case faCircleO =        "\u{f10c}"
        case faInfoCircle =     "\u{f05a}"
    }
    
    enum iconSize: CGFloat {
        case xsmall = 20
        case small = 24
        case medium = 36
        case large = 72
    }
    
    enum thresholdValues: Int {
        case eps_i = 1 //15
        case eps_sd = 2
        case roe_avg = 12
        case bv_i = 5
        case so_reduced = 0
        
        // items with duplicate values
        static let dr_avg = bv_i.rawValue
        static let previous_roi = eps_i.rawValue
        static let expected_roi = eps_i.rawValue
    }
    
    enum iconFont: String {
        case material = "MaterialIcons-Regular"
        case fontAwesome = "FontAwesome"
    }
    
    enum appFont: String {
        case regular =  "HelveticaNeue"
        case bold =     "HelveticaNeue-Bold"
    }
    
    enum measureMetadata: String {
        
        // measure ids
        case roe_avg, eps_i, eps_sd, bv_i, dr_avg, so_reduced, previous_roi, expected_roi, q1, q2, q3, q4, q5, q6
             
        // thresholds for each measure
        func threshold() -> String {
            switch self {
            case .roe_avg:
                return "Threshold: Greater than or equal to 12%"
            case .eps_i, .previous_roi, .expected_roi:
                return "Threshold: Greater than or equal to 15%"
            case .eps_sd:
                return "Threshold: Less than or equal to 1.5"
            case .bv_i:
                return "Threshold: Greater than or equal to 5%"
            case .dr_avg:
                return "Threshold: Less than or equal to 5"
            case .so_reduced:
                return "Threshold: More than or equal to 0 shares"
            default:
                return ""
            }
        }
    
        // description of how each measure is calculated
        func calcDesc() -> String {
            switch self {
            case .roe_avg:
                return "Calculation: The annual return on equity is collected and then the mean is found."
            case .eps_i:
                return "Calculation: The annual earnings per share (EPS) is collected and then the future value formula is applied to determine the growth rate of the EPS."
            case .eps_sd:
                return "Calculation: First, the standard deviation of the EPS values from the last ten years is calculated. Then the difference of the first and last values is compared to three times the standard deviation and a ratio is established. The lower the ratio, the less volatile the the EPS."
            case .bv_i:
                return "Calculation: The annual book value is collected and then the future value formula is applied to determine the growth rate of the BV."
            case .dr_avg:
                return "Calculation: The annual total debt ratio is collected and then the mean is calculated."
            case .so_reduced:
                return "Calculation: The value is found by subtracting the number of shares outstanding in the current year, from the number of shares outstanding ten years earlier."
            case .previous_roi:
                return "Calculation: This value is found by obtaining the stock price 5 years ago, the current price and calculating the growth rate."
            case .expected_roi:
                return "Calculation: To calculate the Expected ROI, the future value of the EPS in ten years is calculated from the current EPS value and the EPS growth rate. The mean value for the P/E ratio is also calculated. Next, the future stock price is found by multiplying the future value EPS by the mean P/E ratio. Finally, the expected ROI is found by using the future value function. The current stock price is the present value and the future value is the future stock price."
            default:
                return ""
            }
        }
    }
}

extension UIColor {
    enum ColorName : UInt32 {
        case blue =             0x0096EAff
        case statusBarBlue =    0x0076B7ff
        case disabledText =     0xCCCCCCff
        case brown =            0x7b4e21ff
        case statusGreen =      0x3DB66Fff
        case statusRed =        0xdf1a21ff
        case beige =            0xF5F5DCff
    }
}

extension UIColor {
    convenience init(named name: ColorName) {
        let rgbaValue = name.rawValue
        let red   = CGFloat((rgbaValue >> 24) & 0xff) / 255.0
        let green = CGFloat((rgbaValue >> 16) & 0xff) / 255.0
        let blue  = CGFloat((rgbaValue >>  8) & 0xff) / 255.0
        let alpha = CGFloat((rgbaValue      ) & 0xff) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
