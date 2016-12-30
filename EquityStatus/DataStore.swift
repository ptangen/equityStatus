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
    
    class func createEquityMetadata(name: String, nameFirst: String, ticker: String, tickerFirst: String) {
        
        let store = DataStore.sharedInstance
        
        // create the core data object
        let context = store.persistentContainer.viewContext
        let equityMetadataInst = NSEntityDescription.insertNewObject(forEntityName: "EquityMetadata", into: context) as! EquityMetadata
        
        // set the properties
        equityMetadataInst.name = name
        equityMetadataInst.nameFirst = nameFirst
        equityMetadataInst.ticker = ticker
        equityMetadataInst.tickerFirst = tickerFirst
        
        // add new equity to dataStore/coredata
        store.equitiesMetadata.append(equityMetadataInst)
        store.saveEquitiesMetadataContext()
        store.getEquitiesMetadataFromCoreData()
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
