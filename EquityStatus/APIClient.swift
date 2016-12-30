//
//  apiClient.swift
//  EquityStatus
//
//  Created by Paul Tangen on 12/19/16.
//  Copyright © 2016 Paul Tangen. All rights reserved.
//

import Foundation
import UIKit

class APIClient {
    
    class func requestAuth(userName: String, password: String, completion: @escaping (AuthResponse) -> Void) {
        
        guard let userNameSubmitted = userName.addingPercentEncoding(withAllowedCharacters: .urlUserAllowed) else {
            completion(.userNameInvalid)
            return
        }
        
        guard let passwordSubmitted = password.addingPercentEncoding(withAllowedCharacters: .urlPasswordAllowed) else {
            completion(.passwordInvalid)
            return
        }
        
        let urlString = "\(Secrets.apiURL)auth.php"
        var request = URLRequest(url: URL(string: urlString)!)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let parameterString = "userNameSubmitted=\(userNameSubmitted)&passwordSubmitted=\(passwordSubmitted)"
        request.httpBody = parameterString.data(using: .utf8)
       
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            if let data = data {
                DispatchQueue.main.async {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String : String]
                        let results = json["results"]
                
                        if results == "authenticated" {
                            completion(.authenticated)
                        } else if results == "userNameInvalid" {
                            completion(.userNameInvalid)
                        } else if results == "passwordInvalid" {
                            completion(.passwordInvalid)
                        } else {
                            completion(.noReply)
                        }
                    } catch {
                        completion(.noReply)
                    }
                }
            }
        }).resume()
    }
    
    class func getEquitiesMetadataFromDB(completion: @escaping () -> Void) {

        let urlString = "\(Secrets.apiURL)getEquitiesMetadata.php"
        var request = URLRequest(url: URL(string: urlString)!)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let parameterString = "key=\(Secrets.apiKey)"
        request.httpBody = parameterString.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            if let unwrappedData = data {
                do {
                    let responseJSON = try JSONSerialization.jsonObject(with: unwrappedData, options: []) as! [[String: String]]
                    for metadataDict in responseJSON {
                        // unwrap the incoming data and create equityMeta entities in core data
                        guard let unwrappedName = metadataDict["name"] else { fatalError() }
                        guard let unwrappedTicker = metadataDict["ticker"] else { fatalError() }
                        guard let unwrappedNameFirst = metadataDict["name"]?.characters.first else { print("Unable to get first initial of name."); return; }
                        guard let unwrappedTickerFirst = metadataDict["ticker"]?.characters.first else { print("Unable to get first initial of ticker."); return; }
                            
                        DataStore.createEquityMetadata(name: unwrappedName, nameFirst: String(unwrappedNameFirst), ticker: unwrappedTicker, tickerFirst: String(unwrappedTickerFirst))
                    }
                    completion()
                } catch {
                    print("An error occurred when creating responseJSON")
                }
            }
        }).resume()
    }
    
    // allPass, noFailures, t:GGG
    class func getEquitiesFromDB(mode: String, completion: @escaping () -> Void) {
        let store = DataStore.sharedInstance
        let urlString = "\(Secrets.apiURL)getEquities.php"
        var request = URLRequest(url: URL(string: urlString)!)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let parameterString = "key=\(Secrets.apiKey)&mode=\(mode)&ByTarget=SomePass"
        request.httpBody = parameterString.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            if let unwrappedData = data {
                do {
                    let responseJSON = try JSONSerialization.jsonObject(with: unwrappedData, options: []) as! [[String: String]]
                    //print(responseJSON)
                    for equityDict in responseJSON {
                        // unwrap the incoming data and create equity
                        guard let unwrappedTicker = equityDict["Ticker"]  else { fatalError() }
                        guard let unwrappedName = equityDict["Name"] else { fatalError() }
                        
                        guard let unwrappedROEaResultString = equityDict["ROEaResult"] else { fatalError() }
                        guard let unwrappedROEaResult = Double(unwrappedROEaResultString) else { fatalError() }
                        
                        guard let unwrappedEPSiResultString = equityDict["EPSiResult"] else { fatalError() }
                        guard let unwrappedEPSiResult = Double(unwrappedEPSiResultString) else { fatalError() }
                        
                        guard let unwrappedEPSvResultString = equityDict["EPSvResult"] else { fatalError() }
                        guard let unwrappedEPSvResult = Double(unwrappedEPSvResultString) else { fatalError() }
                        
                        guard let unwrappedBViResultString = equityDict["BViResult"] else { fatalError() }
                        guard let unwrappedBViResult = Double(unwrappedBViResultString) else { fatalError() }
                        
                        guard let unwrappedDRaResultString = equityDict["DRaResult"] else { fatalError() }
                        guard let unwrappedDRaResult = Double(unwrappedDRaResultString) else { fatalError() }
                        
                        guard let unwrappedSOrResultString = equityDict["SOrResult"] else { fatalError() }
                        guard let unwrappedSOrResult = Double(unwrappedSOrResultString) else { fatalError() }
                        
                        guard let unwrappedPreviousROIResultString = equityDict["previousROIResult"] else { fatalError() }
                        guard let unwrappedPreviousROIResult = Double(unwrappedPreviousROIResultString) else { fatalError() }
                        
                        guard let unwrappedExpectedROIResultString = equityDict["expectedROIResult"] else { fatalError() }
                        guard let unwrappedExpectedROIResult = Double(unwrappedExpectedROIResultString) else { fatalError() }
                        
                        guard let unwrappedROEaStatus = equityDict["ROEaStatus"] else { fatalError() }
                        guard let unwrappedEPSiStatus = equityDict["EPSiStatus"] else { fatalError() }
                        guard let unwrappedEPSvStatus = equityDict["EPSvStatus"] else { fatalError() }
                        guard let unwrappedBViStatus = equityDict["BViStatus"] else { fatalError() }
                        guard let unwrappedDRaStatus = equityDict["DRaStatus"] else { fatalError() }
                        guard let unwrappedSOrStatus = equityDict["SOrStatus"] else { fatalError() }
                        guard let unwrappedPreviousROIStatus = equityDict["previousROIStatus"] else { fatalError() }
                        guard let unwrappedExpectedROIStatus = equityDict["expectedROIStatus"] else { fatalError() }
                        
                        guard let unwrappedQ1Answer = equityDict["q1Answer"] else { fatalError() }
                        guard let unwrappedQ2Answer = equityDict["q2Answer"] else { fatalError() }
                        guard let unwrappedQ3Answer = equityDict["q3Answer"] else { fatalError() }
                        guard let unwrappedQ4Answer = equityDict["q4Answer"] else { fatalError() }
                        guard let unwrappedQ5Answer = equityDict["q5Answer"] else { fatalError() }
                        guard let unwrappedQ6Answer = equityDict["q6Answer"] else { fatalError() }

                        guard let unwrappedQ1Status = equityDict["q1Status"] else { fatalError() }
                        guard let unwrappedQ2Status = equityDict["q2Status"] else { fatalError() }
                        guard let unwrappedQ3Status = equityDict["q3Status"] else { fatalError() }
                        guard let unwrappedQ4Status = equityDict["q4Status"] else { fatalError() }
                        guard let unwrappedQ5Status = equityDict["q5Status"] else { fatalError() }
                        guard let unwrappedQ6Status = equityDict["q6Status"] else { fatalError() }
                        
                        // determine which tab the equity will be displayed
                        var tabValue:String = String()
                        if mode == "pass,noData" {
                            tabValue = "analysis"
                        } else {
                            tabValue = "buy"
                        }
                        
                        let equityInst = Equity(
                            ticker: unwrappedTicker,
                            name: unwrappedName,
                            tab: tabValue,
                            ROEaResult: unwrappedROEaResult,
                            EPSiResult: unwrappedEPSiResult,
                            EPSvResult: unwrappedEPSvResult,
                            BViResult: unwrappedBViResult,
                            DRaResult: unwrappedDRaResult,
                            SOrResult: unwrappedSOrResult,
                            previousROIResult: unwrappedPreviousROIResult,
                            expectedROIResult: unwrappedExpectedROIResult,
                            ROEaStatus: unwrappedROEaStatus,
                            EPSiStatus: unwrappedEPSiStatus,
                            EPSvStatus: unwrappedEPSvStatus,
                            BViStatus: unwrappedBViStatus,
                            DRaStatus: unwrappedDRaStatus,
                            SOrStatus: unwrappedSOrStatus,
                            previousROIStatus: unwrappedPreviousROIStatus,
                            expectedROIStatus: unwrappedExpectedROIStatus,
                            q1Answer: unwrappedQ1Answer,
                            q2Answer: unwrappedQ2Answer,
                            q3Answer: unwrappedQ3Answer,
                            q4Answer: unwrappedQ4Answer,
                            q5Answer: unwrappedQ5Answer,
                            q6Answer: unwrappedQ6Answer,
                            q1Status: unwrappedQ1Status,
                            q2Status: unwrappedQ2Status,
                            q3Status: unwrappedQ3Status,
                            q4Status: unwrappedQ4Status,
                            q5Status: unwrappedQ5Status,
                            q6Status: unwrappedQ6Status)
                        
                        store.equities.append(equityInst)
                    }
                    completion()
                } catch {
                    print("An error occurred when creating responseJSON")
                }
            }
        }).resume()
    }
}

enum AuthResponse {
    case authenticated
    case userNameInvalid
    case passwordInvalid
    case noReply
}
