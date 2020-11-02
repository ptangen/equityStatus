//
//  DataStore.swift
//  EquityStatus
//
//  Created by Paul Tangen on 12/19/16.
//  Copyright © 2016 Paul Tangen. All rights reserved.
//

import Foundation
//import CoreData

class DataStore {
    static let sharedInstance = DataStore()
    fileprivate init() {}
    
    var companies:[Company] = []
    var companiesToEvaluate:[Company] = []
    var companiesToSell:[Company] = []
    
    var measureInfo:[String: [String: String]] = [
        "eps_i": [
            "name": "eps_i",
            "longName": "Earnings Per Share Growth Rate",
            "thresholdDesc":"Threshold: Greater than or equal to 15%",
            "calcDesc": "Calculation: The annual earnings per share (EPS) is collected and then the future value formula is applied to determine the growth rate of the EPS.",
            "pageIndex": "0",
            "units": "%"
        ],
        "eps_sd": [
            "name": "eps_sd",
            "longName": "Earnings Per Share Standard Deviation",
            "thresholdDesc":"Threshold: Less than or equal to 2.0",
            "calcDesc": "Calculation: The standard deviation of the EPS values from the last ten years is calculated. The lower the STD, the less volatile the the EPS.",
            "pageIndex": "1",
            "units": ""
        ],
        "roe_avg": [
            "name": "roe_avg",
            "longName": "Avg Return on Equity",
            "thresholdDesc": "Threshold: Greater than or equal to 12%",
            "calcDesc": "Calculation: The annual return on equity is collected and then the mean is found.",
            "pageIndex": "2",
            "units": "%"
        ],
        "bv_i": [
            "name": "bv_i",
            "longName": "Book Value Growth Rate",
            "thresholdDesc":"Threshold: Greater than or equal to 5%",
            "calcDesc": "Calculation: The annual book value is collected and then the future value formula is applied to determine the growth rate of the BV.",
            "pageIndex": "3",
            "units": "%"
        ],
        "dr_avg": [
            "name": "dr_avg",
            "longName": "Avg Debt Ratio",
            "thresholdDesc":"Threshold: Less than or equal to 5",
            "calcDesc": "Calculation: The annual total debt ratio is collected and then the mean is calculated.",
            "pageIndex": "4",
            "units": ""
        ],
        "so_reduced": [
            "name": "so_reduced",
            "longName": "Shares Outstanding Reduced",
            "thresholdDesc":"Threshold: More than or equal to 0 shares",
            "calcDesc": "Calculation: The value is found by subtracting the number of shares outstanding in the current year, from the number of shares outstanding ten years earlier.",
            "pageIndex": "5",
            "units": ""
        ],
        "pe_change": [
            "name": "pe_change",
            "longName": "P/E Change vs Avg",
            "thresholdDesc":"Threshold: 50% over avg",
            "calcDesc": "Calculation: The value is found by comparing the most recent P/E value and comparing it to the avg.",
            "pageIndex": "6",
            "units": "%"
        ],
        "previous_roi": [
            "name": "previous_roi",
            "longName": "Previous Return on Investment",
            "thresholdDesc": "Threshold: Greater than or equal to 15%",
            "calcDesc": "Calculation: This value is found by obtaining the stock price 5 years ago, the current price and calculating the growth rate.",
            "pageIndex": "7",
            "units": "%"
        ],
        "expected_roi": [
            "name": "expected_roi",
            "longName": "Expected Return on Investment",
            "thresholdDesc":"Threshold: Greater than or equal to 15%",
            "calcDesc": "Calculation: To calculate the Expected ROI, the future value of the EPS in ten years is calculated from the current EPS value and the EPS growth rate. The mean value for the P/E ratio is also calculated. Next, the future stock price is found by multiplying the future value EPS by the mean P/E ratio. Finally, the expected ROI is found by using the future value function. The current stock price is the present value and the future value is the future stock price.",
            "pageIndex": "8",
            "units": "%"
        ],
        "q1": [
            "name": "q1",
            "longName": "Is there a strong upward trend in the EPS?",
            "pageIndex": "9",
        ],
        "q2": [
            "name": "q2",
            "longName": "Do you understand the product/service?",
            "pageIndex": "10",
        ],
        "q3": [
            "name": "q3",
            "longName": "Has the product/service been consistent for 10 years?",
            "pageIndex": "11",
        ],
        "q4": [
            "name": "q4",
            "longName": "Does the company invest in it's area of expertise?",
            "pageIndex": "12",
        ],
        "q5": [
            "name": "q5",
            "longName": "Are few expenditures required to maintain operations?",
            "pageIndex": "13",
        ],
        "q6": [
            "name": "q6",
            "longName": "Is the company free to adjust prices with inflation?",
            "pageIndex": "14",
        ],
        "own": [
            "name": "own",
            "longName": "Do we own stock in this company?",
            "pageIndex": "15",
        ]
        
    ]
}
