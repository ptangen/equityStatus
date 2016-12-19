//
//  DataStore.swift
//  EquityStatus
//
//  Created by Paul Tangen on 12/19/16.
//  Copyright © 2016 Paul Tangen. All rights reserved.
//

import Foundation

class DataStore {
    static let sharedInstance = DataStore()
    fileprivate init() {}
    
    var userName: String = String()
    var authenticated: Bool = false

}
