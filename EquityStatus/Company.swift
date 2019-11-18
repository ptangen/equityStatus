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
    var fyEndMonth: Int
    
    init(ticker: String, name:String, fyEndMonth:Int) {
        self.ticker = ticker
        self.name = name
        self.fyEndMonth = fyEndMonth
    }
}

