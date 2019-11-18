//
//  DBUtilitites.swift
//  EquityStatus
//
//  Created by Paul Tangen on 11/13/19.
//  Copyright © 2019 Paul Tangen. All rights reserved.
//

import Foundation
import SQLite

class DBUtilities {
    
    

    
//    func createDB(){
//        print("create db")
//        // create file for DB
//        do {
//            let doctumentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
//            let fileurl = doctumentDirectory.appendingPathComponent("equityStatus").appendingPathExtension("sqlite3")
//            let database = try Connection(fileurl.path)
//            self.database = database
//        } catch {
//            print(error)
//        }
//    }
    
    class func createDB(){
        var database: Connection!
        
        // define tickers table
        let tickers = Table("tickers")
        let id = Expression<String>("id")
        let name = Expression<String?>("name")
        let fyEndMonth = Expression<Int?>("fyEndMonth")
        
        print("create db")
        // create file for DB
        do {
            let doctumentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileurl = doctumentDirectory.appendingPathComponent("equityStatus").appendingPathExtension("sqlite3")
            database = try Connection(fileurl.path)
            //self.database = database
        } catch {
            print(error)
        }
        
        // create tickers table
//        let sqlStatement = tickers.create{ (table) in
//            table.column(id, primaryKey: true)
//            table.column(name)
//            table.column(fyEndMonth)
//        }
        
        // insert a row
//        let sqlStatement = tickers.insert(id <- "BBB", fyEndMonth <- 09)
        // run create insert
//        do {
//            try database.run(sqlStatement)
//            print("sqlStatement completed")
//        } catch {
//            print(error)
//        }
        
        // select rows from table
        do {
            let tickers = try database.prepare(tickers)
            for ticker in tickers {
                print("id: \(ticker[id]), fyEndMonth: \(String(describing: ticker[fyEndMonth]))")
            }
        } catch {
            print(error)
        }
    }
    
//    class func setupDB(){
//        DBUtilities.createDB()
//        DBUtilities.createTable()
//    }
    
    class func fetchValues() {
        print("fetchValues")
//        APIClient.requestRawData(measure: "basiceps", ticker: "AAPL", completion: { response in
//            if let responseUnwrapped = response["message"]{
//                print(responseUnwrapped)
//            }
//            if let responseUnwrapped = response["extractedValues"]{
//                print(responseUnwrapped)
//                // calc EPSi
//                // calc EPSv
//            }
//                
//        }) // end apiClient.requestAuth
        
    }
}
