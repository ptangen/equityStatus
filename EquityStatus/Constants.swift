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
        case ROEa, EPSi, EPSv, BVi, DRa, SOr, previousROI, expectedROI, q1, q2, q3, q4, q5, q6
        
        // long names for the measures
        func longName() -> String {
            switch self {
            case .ROEa:
                return "Avg Return on Equity"
            case .EPSi:
                return "Earnings Per Share Growth Rate"
            case .EPSv:
                return "Earnings Per Share Volatility"
            case .BVi:
                return "Book Value Growth Rate"
            case .DRa:
                return "Avg Debt Ratio"
            case .SOr:
                return "Shares Outstanding Reduced"
            case .previousROI:
                return "Previous Return on Investment"
            case .expectedROI:
                return "Expected Return on Investment"
            case .q1:
                return "Is there a strong upward trend in the EPS?"
            case .q2:
                return "Do you understand the product/service?"
            case .q3:
                return "Has the product/service been consistent for 10 years?"
            case .q4:
                return "Does the company invest in it's area of expertise?"
            case .q5:
                return "Are few expenditures required to maintain operations?"
            case .q6:
                return "Is the company free to adjust prices with inflation?"
            }
        }
        
        // use these labels to gether historical data for the charts on the measures listed below
        func historicalDataLabel() -> String {
            switch self {
            case .ROEa:
                return "ReturnOnEquity"
            case .EPSi, .EPSv:
                return "EarningsPerShare"
            case .BVi:
                return "BookValuePerShare"
            case .DRa:
                return "DebtEquity"
            case .SOr:
                return "Shares"
            case .q1:
                return "EarningsPerShare"
            default:
                return ""
            }
        }
        
        // use these labels to gether historical data for the charts on the measures listed below
        func chartLabel() -> String {
            switch self {
            case .ROEa:
                return "  Return On Equity (%)"
            case .EPSi, .EPSv, .q1:
                return "  Earnings Per Share ($)"
            case .BVi:
                return "  Book Value Per Share ($)"
            case .DRa:
                return "  Debt Equity Ratio"
            case .SOr:
                return "  Shares Outstanding"
            default:
                return ""
            }
        }
        
        // long names for the measures
        func index() -> Int {
            switch self {
            case .ROEa:
                return 0
            case .EPSi:
                return 1
            case .EPSv:
                return 2
            case .BVi:
                return 3
            case .DRa:
                return 4
            case .SOr:
                return 5
            case .previousROI:
                return 6
            case .expectedROI:
                return 7
            case .q1:
                return 8
            case .q2:
                return 9
            case .q3:
                return 10
            case .q4:
                return 11
            case .q5:
                return 12
            case .q6:
                return 13
            }
        }
        
        // thresholds for each measure
        func threshold() -> String {
            switch self {
            case .ROEa:
                return "Threshold: Greater than or equal to 12%"
            case .EPSi, .previousROI, .expectedROI:
                return "Threshold: Greater than or equal to 15%"
            case .EPSv:
                return "Threshold: Less than or equal to 1.5"
            case .BVi:
                return "Threshold: Greater than or equal to 5%"
            case .DRa:
                return "Threshold: Less than or equal to 5"
            case .SOr:
                return "Threshold: More than or equal to 0 shares"
            default:
                return ""
            }
        }
    
        // description of how each measure is calculated
        func calcDesc() -> String {
            switch self {
            case .ROEa:
                return "Calculation: The annual return on equity is collected and then the mean is found."
            case .EPSi:
                return "Calculation: The annual earnings per share (EPS) is collected and then the future value formula is applied to determine the growth rate of the EPS."
            case .EPSv:
                return "Calculation: First, the standard deviation of the EPS values from the last ten years is calculated. Then the difference of the first and last values is compared to three times the standard deviation and a ratio is established. The lower the ratio, the less volatile the the EPS."
            case .BVi:
                return "Calculation: The annual book value is collected and then the future value formula is applied to determine the growth rate of the BV."
            case .DRa:
                return "Calculation: The annual total debt ratio is collected and then the mean is calculated."
            case .SOr:
                return "Calculation: The value is found by subtracting the number of shares outstanding in the current year, from the number of shares outstanding ten years earlier."
            case .previousROI:
                return "Calculation: This value is found by obtaining the stock price 5 years ago, the current price and calculating the growth rate."
            case .expectedROI:
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
