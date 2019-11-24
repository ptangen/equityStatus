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
    var epsi: Int?
    var epsv: Double?
    var roei: Int?
    
//    convenience init(sender: String) {
//        self.init(sender: sender, recipient: sender)
//    }
    
//    convenience init(ticker: String, name:String) {
//        self.ticker = ticker
//        self.name = name
//        super.init(ticker: ticker, name: name)
//    }
    
    init(ticker: String, name:String) {
        self.ticker = ticker
        self.name = name
//        self.epsi = epsi
//        self.epsv = epsv
//        self.roei = roei
    }
}

