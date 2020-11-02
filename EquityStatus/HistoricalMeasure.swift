//
//  HistoricalMeasure.swift
//  EquityStatus
//
//  Created by Paul Tangen on 10/25/20.
//  Copyright © 2020 Paul Tangen. All rights reserved.
//

import Foundation

class HistoricalMeasure {
    var ticker: String
    var date: Date
    var eps: Double?
    var so: Int?
    var dr: Double?
    var pe: Double?
    var roe: Double?
    var bv: Double?
    
    init(ticker: String, date: Date, eps: Double?, so: Int?, dr: Double?, pe: Double?, roe: Double?, bv: Double?) {
        self.ticker = ticker
        self.date = date
        self.eps = eps
        self.so = so
        self.dr = dr
        self.pe = pe
        self.roe = roe
        self.bv = bv
    }
    
    convenience init(ticker: String, date: Date) {
        self.init(ticker: ticker, date: date, eps: nil, so: nil, dr: nil, pe: nil, roe: nil, bv: nil )
    }
}
