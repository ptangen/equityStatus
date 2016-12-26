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
        case chevron_left =     "\u{E5CB}"
        case chevron_right =    "\u{E5CC}"
        case close =            "\u{E5CD}"
        case menu =             "\u{E5D2}"
        case faCheckCircle =    "\u{f058}"
        case faTimesCircle =    "\u{f057}"
        case faCircleO =        "\u{f10c}"
    }
    
    enum iconSize: Int {
        case xsmall = 16
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
}

extension UIColor {
    enum ColorName : UInt32 {
        case gold =     0xFFCC66ff
        case blue =     0x174BB2ff
        case white =    0xffffffff
        case beige =    0xf5d1b1ff
        case black =    0x999999ff
        case gray3 =    0x333333ff
        case orange =   0xFF851Bff
        case disabledText = 0xCCCCCCff
        case loginGray = 0xCAD0DCff
        case loginTan = 0x91623eff
        case esGreen =  0x53d769ff
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
