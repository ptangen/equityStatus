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
    
    func resetTabValue(equity: Equity) {
        // determine if equity belongs in evaluation tab
        if equity.ROEaStatus == "pass" &&
            equity.EPSiStatus == "pass" &&
            equity.EPSvStatus == "pass" &&
            equity.BViStatus == "pass" &&
            equity.DRaStatus == "pass" &&
            equity.SOrStatus == "pass" &&
            equity.previousROIStatus == "pass" &&
            equity.expectedROIStatus == "pass" &&
            equity.q1Status != "fail" &&
            equity.q2Status != "fail" &&
            equity.q3Status != "fail" &&
            equity.q4Status != "fail" &&
            equity.q5Status != "fail" &&
            equity.q6Status != "fail"
        {
            equity.tab = .evaluate
            self.setShowInSellTab(equity: equity, value: false)
            
        } else {
            equity.tab = .sell
            self.setShowInSellTab(equity: equity, value: true)
            
        }
        
        // determine if any of the items in the evaluate tab should move to the buy tab
        if equity.tab == .evaluate &&
            equity.q1Status == "pass" &&
            equity.q2Status == "pass" &&
            equity.q3Status == "pass" &&
            equity.q4Status == "pass" &&
            equity.q5Status == "pass" &&
            equity.q6Status == "pass"
        {
            equity.tab = .buy
            self.setShowInSellTab(equity: equity, value: false)
        }
    }
    
    func setShowInSellTab(equity: Equity, value: Bool) {
        // get peer equity
        for equityMetadata in equitiesMetadata {
            if equityMetadata.ticker == equity.ticker {
                equityMetadata.showInSellTab = value
                
            }
        }
        self.saveEquitiesMetadataContext()
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
