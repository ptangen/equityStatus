//
//  DataStore.swift
//  EquityStatus
//
//  Created by Paul Tangen on 12/19/16.
//  Copyright © 2016 Paul Tangen. All rights reserved.
//

import Foundation
import CoreData

class DataStore {
    static let sharedInstance = DataStore()
    fileprivate init() {}
    var equitiesMetadata:[EquityMetadata] = []
    var equities:[Equity] = []
    var equitiesForBuyNames = [String]()
    var equitiesForEvaluation = [Equity]()
    
    var companies:[Company] = []
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
            "longName": "Earnings Per Share Volatility",
            "thresholdDesc":"Threshold: Less than or equal to 2.0",
            "calcDesc": "Calculation: First, the standard deviation of the EPS values from the last ten years is calculated. Then the difference of the first and last values is compared to three times the standard deviation and a ratio is established. The lower the ratio, the less volatile the the EPS.",
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
        "previous_roi": [
            "name": "previous_roi",
            "longName": "Previous Return on Investment",
            "thresholdDesc": "Threshold: Greater than or equal to 15%",
            "calcDesc": "Calculation: This value is found by obtaining the stock price 5 years ago, the current price and calculating the growth rate.",
            "pageIndex": "6",
            "units": "%"
        ],
        "expected_roi": [
            "name": "expected_roi",
            "longName": "Expected Return on Investment",
            "thresholdDesc":"Threshold: Greater than or equal to 15%",
            "calcDesc": "Calculation: To calculate the Expected ROI, the future value of the EPS in ten years is calculated from the current EPS value and the EPS growth rate. The mean value for the P/E ratio is also calculated. Next, the future stock price is found by multiplying the future value EPS by the mean P/E ratio. Finally, the expected ROI is found by using the future value function. The current stock price is the present value and the future value is the future stock price.",
            "pageIndex": "7",
            "units": "%"
        ],
        "q1": [
            "name": "q1",
            "longName": "Is there a strong upward trend in the EPS?",
            "pageIndex": "8",
        ],
        "q2": [
            "name": "q2",
            "longName": "Do you understand the product/service?",
            "pageIndex": "9",
        ],
        "q3": [
            "name": "q3",
            "longName": "Has the product/service been consistent for 10 years?",
            "pageIndex": "10",
        ],
        "q4": [
            "name": "q4",
            "longName": "Does the company invest in it's area of expertise?",
            "pageIndex": "11",
        ],
        "q5": [
            "name": "q5",
            "longName": "Are few expenditures required to maintain operations?",
            "pageIndex": "12",
        ],
        "q6": [
            "name": "q6",
            "longName": "Is the company free to adjust prices with inflation?",
            "pageIndex": "13",
        ]
        
    ]
    
    func getTickersInEvalAndBuy() -> [String] {
        var tickersInEvalAndBuy: [String] = []
        for equity in self.equities {
            tickersInEvalAndBuy.append(equity.ticker)
        }
        return tickersInEvalAndBuy
    }
    
    class func createEquityMetadata(name: String, nameFirst: String, ticker: String, tickerFirst: String) {
        
        let store = DataStore.sharedInstance
        let tickersInEvalAndBuy = store.getTickersInEvalAndBuy()
        
        // create the core data object
        let context = store.persistentContainer.viewContext
        let equityMetadataInst = NSEntityDescription.insertNewObject(forEntityName: "EquityMetadata", into: context) as? EquityMetadata
        
        // set the properties
        if let equityMetadataInst = equityMetadataInst {
            equityMetadataInst.name = name
            equityMetadataInst.nameFirst = nameFirst
            equityMetadataInst.ticker = ticker
            equityMetadataInst.tickerFirst = tickerFirst
        
            if tickersInEvalAndBuy.contains(ticker) {
                equityMetadataInst.showInSellTab = false
            } else {
                equityMetadataInst.showInSellTab = true
            }
        
            // add new equity to dataStore/coredata
            store.equitiesMetadata.append(equityMetadataInst)
            store.saveEquitiesMetadataContext()
            store.getEquitiesMetadataFromCoreData()
        }
    }
    
    func getEquityByTickerFromStore(ticker: String) -> Equity? {
        for equity in self.equities {
            if equity.ticker == ticker  {
                return equity
            }
        }
        return nil
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "EquityStatus") // name must match model file
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveEquitiesMetadataContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func getEquitiesMetadataFromCoreData() {
        let context = persistentContainer.viewContext
        let equitiesMetadataRequest: NSFetchRequest<EquityMetadata> = EquityMetadata.fetchRequest()
        
        do {
            self.equitiesMetadata = try context.fetch(equitiesMetadataRequest)
        } catch let error {
            print("Error fetching data: \(error)")
        }
    }
}
