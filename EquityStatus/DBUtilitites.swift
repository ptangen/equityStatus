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
    
    class func removeDBFile(){
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileurl = documentDirectory.appendingPathComponent("equityStatus").appendingPathExtension("sqlite3")
            try FileManager.default.removeItem(at: fileurl)
            //print("remove database file")
        } catch {
            print("no database file found: \(error)")
        }
    }

    class func getDBConnection() -> Connection {
        // doc: https://github.com/stephencelis/SQLite.swift/blob/master/Documentation/Index.md#updating-rows
        // if file for DB does not exist, a file is created for the DB
        var database: Connection!
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileurl = documentDirectory.appendingPathComponent("equityStatus").appendingPathExtension("sqlite3")
            database = try Connection(fileurl.path)
            
            // get size of DB
            let showDBSize = false
            if(database != nil && showDBSize){
                let fileSizeKB = (try FileManager.default.attributesOfItem(atPath: fileurl.path)[FileAttributeKey.size] as! NSNumber).uint64Value/1024
                print("file size: \(fileSizeKB) KB")
            }
        } catch {
            print("no table \(error)")
        }
        return database
    }
}
