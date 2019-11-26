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
    
    init(ticker: String, name:String) {
        self.ticker = ticker
        self.name = name
    }
}

