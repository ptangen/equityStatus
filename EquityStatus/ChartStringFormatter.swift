//
//  ChartStringFormatter.swift
//  EquityStatus
//
//  Created by Paul Tangen on 12/20/16.
//  Copyright © 2016 Paul Tangen. All rights reserved.
//

import Foundation
import Charts


class ChartStringFormatter: NSObject, IAxisValueFormatter {
    
    var nameValues: [String]!
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return String(describing: nameValues[Int(value)])
    }
}
