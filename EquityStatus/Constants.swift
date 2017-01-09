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
    }
    
    enum iconLibrary: String {
        //case chevron_left =     "\u{E5CB}"
        //case chevron_right =    "\u{E5CC}"
        //case close =            "\u{E5CD}"
        case menu =             "\u{E5D2}"
        case faCheckCircle =    "\u{f058}"
        case faTimesCircle =    "\u{f057}"
        case faCircleO =        "\u{f10c}"
    }
    
    enum iconSize: Int {
        case xsmall = 20
        case small = 24
        case medium = 36
        case large = 72
    }
    
    enum iconFont: String {
        case material = "MaterialIcons-Regular"
        case fontAwesome = "FontAwesome"
    }
    
    enum appFont: String {
        case regular =  "HelveticaNeue"
        case bold =     "HelveticaNeue-Bold"
    }
    
    enum measureLongName: String {
        case ROEa = "Avg Return on Equity"
        case EPSi = "Earnings Per Share Growth Rate"
        case EPSv = "Earnings Per Share Volatility"
        case BVi = "Book Value Growth Rate"
        case DRa = "Avg Debt Ratio"
        case SOr = "Shares Outstanding Reduced"
        case previousROI = "Previous Return on Investment"
        case expectedROI = "Expected Return on Investment"
        case q1 = "Is there a strong upward trend in the EPS?"
        case q2 = "Do you understand the product/service?"
        case q3 = "Has the product/service been consistent for 10 years?"
        case q4 = "Does the company invest in it's area of expertise?"
        case q5 = "Are few expenditures required to maintain operations?"
        case q6 = "Is the company free to adjust prices with inflation?"
    }
    
    enum measureTargetDesc: String {
        case ROEa = "greater than or equal to 12%"
        case EPSi = "greater than or equal to 12% "
        case previousROI = "greater than or equal to 20%"
        case expectedROI = "greater than or equal to 15%"
        case EPSv = "less than or equal to 1.5"
        case BVi = "greater than or equal to 5%"
        case DRa = "less than or equal to 5"
        case SOr = "more than or equal to 0 shares"
    }
     //EPSi = 15, previousROI = 15, expectedROI = 15
    
    enum measureCalcDesc: String {
        case ROEa = "The annual return on equity is collected and then the mean is found."
        case EPSi = "The annual earnings per share (EPS) is collected and then the future value formula is applied to determine the growth rate of the EPS."
        case EPSv = "The Buffet methodology stresses the importance of a stable EPS growth rate. The methodology does not provide a formula, but a rough calculation was found for this measure. The calculation first finds the standard deviation of the EPS values from the last ten years. Then the difference of the first and last values is compared to three times the standard deviation and a ratio is established. The lower the ratio, the less volatile the the EPS."
        case BVi = "The annual book value is collected and then the future value formula is applied to determine the growth rate of the BV."
        case DRa = "The annual total debt ratio is collected and then the mean is calculated."
        case SOr = "The annual number of shares outstanding is collected. Then the value is found by subtracting the number of shares outstanding, from the current year, from the number of shares outstanding ten years earlier."
        case previousROI = "This value is found by obtaining the stock price 5 years ago, the current price and calculating the growth rate."
        case expectedROI = "To calculate the Expected ROI, the future value of the EPS in ten years is calculated from the current EPS value and the EPS growth rate. The mean value for the P/E ratio is also calculated. Next, the future stock price is found by multiplying the future value EPS by the mean P/E ratio. Finally, the expected ROI is found by using the future value function. The current stock price is the present value and the future value is the future stock price."
    }
}

extension UIColor {
    enum ColorName : UInt32 {
        //case gold =     0xFFCC66ff
        case blue =     0x0096EAff
        case statusBarBlue = 0x0076B7ff
        //case white =    0xffffffff
        //case beige =    0xf5d1b1ff
        //case black =    0x999999ff
        //case gray3 =    0x333333ff
        //case orange =   0xFF851Bff
        case disabledText = 0xCCCCCCff
        //case loginGray =    0xCAD0DCff
        case brown =        0x7b4e21ff
        case statusGreen =  0x3DB66Fff
        case statusRed =    0xdf1a21ff
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
