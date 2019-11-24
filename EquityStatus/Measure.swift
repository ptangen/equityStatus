//
//  Measure.swift
//  EquityStatus
//
//  Created by Paul Tangen on 11/18/19.
//  Copyright © 2019 Paul Tangen. All rights reserved.
//

import Foundation

class Measure {
    var ticker: String
    var name: String
    var value: Int
    var passed: Bool
    
    init(ticker: String, name:String, value: Int, passed:Bool) {
        self.ticker = ticker
        self.name = name
        self.value = value
        self.passed = passed
    }
}
