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
    
    class func requestAuth(userName: String, password: String, completion: @escaping (apiResponse) -> Void) {
        
        guard let userNameSubmitted = userName.addingPercentEncoding(withAllowedCharacters: .urlUserAllowed) else {
            completion(.userNameInvalid)
            return
        }
        
        guard let passwordSubmitted = password.addingPercentEncoding(withAllowedCharacters: .urlPasswordAllowed) else {
            completion(.passwordInvalid)
            return
        }
        
        let urlString = "\(Secrets.apiURL)auth.php"
        let url = URL(string: urlString)
        if let url = url {
            var request = URLRequest(url: url)

            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
            let parameterString = "userNameSubmitted=\(userNameSubmitted)&passwordSubmitted=\(passwordSubmitted)"
            request.httpBody = parameterString.data(using: .utf8)
       
            URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
                if let data = data {
                    DispatchQueue.main.async {
                        do {
                            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : String]
                            let results = json?["results"]
                
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
        } else {
            print("error: unable to unwrap url")
        }
    }
    
    class func setSubjectiveStatus(ticker: String, question: String, status: String, equity: Equity, completion: @escaping (apiResponse) -> Void) {
        
        let urlString = "\(Secrets.apiURL)setSubjectiveStatus.php"
        let url = URL(string: urlString)
        if let url = url {
            var request = URLRequest(url: url)
        
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
            let parameterString = "ticker=\(ticker)&question=\(question)&status=\(status)&key=\(Secrets.apiKey)"
            request.httpBody = parameterString.data(using: .utf8)

            URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
                if let data = data {
                    DispatchQueue.main.async {
                        do {
                            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Int]
                            if let results = json?["results"] {
                                if results == 1 {
                                    // update the equity
                                    switch question {
                                    case "q1": equity.q1Status = status
                                    case "q2": equity.q2Status = status
                                    case "q3": equity.q3Status = status
                                    case "q4": equity.q4Status = status
                                    case "q5": equity.q5Status = status
                                    case "q6": equity.q6Status = status
                                    default: print("error 121")
                                    }
                                    completion(.ok)
                            
                                } else if results == -1 {
                                    completion(.failed)
                                } else {
                                    completion(.noReply)
                                }
                            }
                        } catch {
                            completion(.noReply)
                        }
                    }
                }
            }).resume()
        } else {
            print("error: unable to unwrap url")
        }
    }
    
    class func getEquitiesMetadataFromDB(completion: @escaping (Bool) -> Void) {

        let urlString = "\(Secrets.apiURL)getEquitiesMetadata.php"
        let url = URL(string: urlString)
        if let url = url {
            var request = URLRequest(url: url)
        
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
            let parameterString = "key=\(Secrets.apiKey)"
            request.httpBody = parameterString.data(using: .utf8)
        
            URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
                if let unwrappedData = data {
                    do {
                        let responseJSON = try JSONSerialization.jsonObject(with: unwrappedData, options: []) as? [[String: String]]
                        if let responseJSON = responseJSON {
                            for metadataDict in responseJSON {
                                // unwrap the incoming data and create equityMeta entities in core data
                                if let unwrappedName = metadataDict["name"], let unwrappedTicker = metadataDict["ticker"] {
                            
                                    let unwrappedNameFirst = unwrappedName.characters.first
                                    let unwrappedTickerFirst = unwrappedTicker.characters.first
                            
                                    DataStore.createEquityMetadata(name: unwrappedName, nameFirst: String(describing: unwrappedNameFirst), ticker: unwrappedTicker, tickerFirst: String(describing: unwrappedTickerFirst))
                                }
                            }
                        }
                        completion(true)
                    } catch {
                        // An error occurred when creating responseJSON
                        completion(false)
                    }
                }
            }).resume()
        } else {
            print("error: unable to unwrap url")
        }
    }
    
    // allPass, noFailures, t:GGG
    class func getEquitiesFromDB(mode: String, completion: @escaping (Bool) -> Void) {
        let store = DataStore.sharedInstance
        let urlString = "\(Secrets.apiURL)getEquities.php"
        let url = URL(string: urlString)
        if let url = url {
            var request = URLRequest(url: url)
        
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
            let parameterString = "key=\(Secrets.apiKey)&mode=\(mode)&ByTarget=SomePass"
            request.httpBody = parameterString.data(using: .utf8)
        
            URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
                if let unwrappedData = data {
                    do {
                        let responseJSON = try JSONSerialization.jsonObject(with: unwrappedData, options: []) as? [[String: String]]
                        //print(responseJSON)
                        if let responseJSON = responseJSON {
                            for equityDict in responseJSON {
                                // unwrap the incoming data and create equity
                        
                                if let unwrappedTicker = equityDict["Ticker"],
                                    let unwrappedName = equityDict["Name"],
                            
                                    // extract the financial results from the equityDict into strings
                                    let unwrappedROEaResultString = equityDict["ROEaResult"],
                                    let unwrappedEPSiResultString = equityDict["EPSiResult"],
                                    let unwrappedEPSvResultString = equityDict["EPSvResult"],
                                    let unwrappedBViResultString = equityDict["BViResult"],
                                    let unwrappedDRaResultString = equityDict["DRaResult"],
                                    let unwrappedSOrResultString = equityDict["SOrResult"],
                                    let unwrappedPreviousROIResultString = equityDict["previousROIResult"],
                                    let unwrappedExpectedROIResultString = equityDict["expectedROIResult"],
                            
                                    // convert the financial results into doubles
                                    let unwrappedROEaResult = Double(unwrappedROEaResultString),
                                    let unwrappedEPSiResult = Double(unwrappedEPSiResultString),
                                    let unwrappedEPSvResult = Double(unwrappedEPSvResultString),
                                    let unwrappedBViResult = Double(unwrappedBViResultString),
                                    let unwrappedDRaResult = Double(unwrappedDRaResultString),
                                    let unwrappedSOrResult = Double(unwrappedSOrResultString),
                                    let unwrappedPreviousROIResult = Double(unwrappedPreviousROIResultString),
                                    let unwrappedExpectedROIResult = Double(unwrappedExpectedROIResultString),
                        
                                    // extract the financial status values from the equityDict
                                    let unwrappedROEaStatus = equityDict["ROEaStatus"],
                                    let unwrappedEPSiStatus = equityDict["EPSiStatus"],
                                    let unwrappedEPSvStatus = equityDict["EPSvStatus"],
                                    let unwrappedBViStatus = equityDict["BViStatus"],
                                    let unwrappedDRaStatus = equityDict["DRaStatus"],
                                    let unwrappedSOrStatus = equityDict["SOrStatus"],
                                    let unwrappedPreviousROIStatus = equityDict["previousROIStatus"],
                                    let unwrappedExpectedROIStatus = equityDict["expectedROIStatus"],
                        
                                    // extract the question answers and status from the equityDict
                                    let unwrappedQ1Answer = equityDict["q1Answer"],
                                    let unwrappedQ1Status = equityDict["q1Status"],
                            
                                    let unwrappedQ2Answer = equityDict["q2Answer"],
                                    let unwrappedQ2Status = equityDict["q2Status"],
                            
                                    let unwrappedQ3Answer = equityDict["q3Answer"],
                                    let unwrappedQ3Status = equityDict["q3Status"],
                        
                                    let unwrappedQ4Answer = equityDict["q4Answer"],
                                    let unwrappedQ4Status = equityDict["q4Status"],
                        
                                    let unwrappedQ5Answer = equityDict["q5Answer"],
                                    let unwrappedQ5Status = equityDict["q5Status"],
                        
                                    let unwrappedQ6Answer = equityDict["q6Answer"],
                                    let unwrappedQ6Status = equityDict["q6Status"] {
                        
                                    // create the object
                                    let equityInst = Equity(
                                        ticker: unwrappedTicker,
                                        name: unwrappedName,
                                        tab: .notSet,
                                
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
                        
                                    // add the new tickers to the datastore and set the tab value
                                    if store.getEquityByTickerFromStore(ticker: equityInst.ticker) == nil {
                                        store.equities.append(equityInst)
                                        store.resetTabValue(equity: equityInst)
                                    }
                                }
                            }
                        }
                        completion(true)
                    } catch {
                        // An error occurred when creating responseJSON
                        completion(false)
                    }
                }
            }).resume()
        } else {
            print("error: unable to unwrap url")
        }
    }
}

enum apiResponse {
    case authenticated
    case userNameInvalid
    case passwordInvalid
    case noReply
    case ok
    case failed
}
