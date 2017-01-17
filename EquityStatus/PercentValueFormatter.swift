//
//  PercentValueFormatter.swift
//  EquityStatus
//
//  Created by Paul Tangen on 12/26/16.
//  Copyright © 2016 Paul Tangen. All rights reserved.
//

import Foundation
import Charts


class PercentValueFormatter: NSObject, IValueFormatter {
    // this code came from the sample chart project
    
    fileprivate static let MAX_LENGTH = 5
    
    /// Suffix to be appended after the values.
    ///
    /// **default**: suffix: ["", "k", "m", "b", "t"]
    open var suffix = ["%", "k", "m", "b", "t"]
    
    /// An appendix text to be added at the end of the formatted value.
    open var appendix: String?
    
    public override init()
    {
        
    }
    
    public init(appendix: String?)
    {
        self.appendix = appendix
    }
    
    fileprivate func format(value: Double) -> String
    {
        var sig = value
        var length = 0
        let maxLength = suffix.count - 1
        
        while sig >= 1000.0 && length < maxLength
        {
            sig /= 1000.0
            length += 1
        }
        
        var r = String(format: "%2.f", sig) + suffix[length]
        
        if let appendix = appendix
        {
            r += appendix
        }
        
        return r
    }
    
    open func stringForValue(
        _ value: Double, axis: AxisBase?) -> String
    {
        return format(value: value)
    }
    
    open func stringForValue(
        _ value: Double,
        entry: ChartDataEntry,
        dataSetIndex: Int,
        viewPortHandler: ViewPortHandler?) -> String
    {
        return format(value: value)
    }

}
