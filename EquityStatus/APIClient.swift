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
    
    class func requestCompanies(completion: @escaping ([String: Any]) -> Void) {
        // get values for some measure from the API
        let urlString = "https://api-v2.intrinio.com/securities"
        let url = URL(string: urlString)
        if let url = url {
            var request = URLRequest(url: url)
            
            print("requestCompanies")

            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
            let parameterString = "api_key=\(Secrets.intrinioKey)&currency=USD&code=EQS&composite_mic=USCOMP"
            request.httpBody = parameterString.data(using: .utf8)
       
            URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
                if let data = data {
                    DispatchQueue.main.async {
                        do {
                            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                            
                            //print(json)
                            if let results = json?["message"] {
                                //print(results)
                                completion(["message": results])
                            } else if let results = json?["securities"] as? [Any] {
                                //print(results)
                                completion(["results": results])
                            } else {
                                completion(["message": "no data found"])
                            }
                        } catch {
                            print("server not found")
                            completion(["message": "server not found"])
                        }
                    }
                }
                if let error = error {
                    completion(["message": error])
                }
            }).resume()
        } else {
            print("error: unable to unwrap url")
        }
    }
    
   
    
    class func requestHistoricalData(ticker: String, measure: String, completion: @escaping ([String: Any]) -> Void) {
        let apiTags:[String: String] = [
            "eps_i": "basiceps",
            "roe_avg": "roe",
            "bv_i": "bookvaluepershare",
            "dr_avg": "debttoequity",
            "so_reduced": "weightedavebasicsharesos",
            "pe_avg": "pricetoearnings"
        ]
        let urlString = "https://api-v2.intrinio.com/historical_data/\(ticker)/\(apiTags[measure]!)"
        let url = URL(string: urlString)
        if let url = url {
            var request = URLRequest(url: url)
            
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
            let parameterString = "sort_order=desc&frequency=quarterly&api_key=\(Secrets.intrinioKey)"
            request.httpBody = parameterString.data(using: .utf8)

            URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
                if let data = data {
                    DispatchQueue.main.async {
                        do {
                            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                            if let message = (json?["message"]) {
                                completion(["error": message as! String])
                            } else if let epsArr = json?["historical_data"] {
                                //print("historical data: \(epsArr)")
                                var epsValues = [Double]()
                                var nilValueFound: Bool = false
                                for eps in epsArr as! [[String: Any?]] {
                                    if let epsValue = (eps["value"]) {
                                        if epsValues.count < 40 && !nilValueFound {
                                            // collect values for the most recent 40 quarters
                                            //print("value to append: \(String(describing: epsValue))")
                                            if let epsValueUnwrapped = epsValue as! Double? {
                                                epsValues.append(epsValueUnwrapped)
                                            } else {
                                                nilValueFound = true // after no value found dont add remaining values
                                            }
                                        }
                                    }
                                }
                                //print(epsValues)
                                completion(["results": epsValues])
                            } else {
                                completion(["error": "no data found" as String])
                            }
                        } catch {
                            print("server not found")
                            completion(["results": "server not found"])
                        }
                    }
                }
                if let error = error {
                    completion(["message": error])
                }
            }).resume()
        } else {
            print("error: unable to unwrap url")
        }
    }
    
    class func getStockPrices(tickers: [String], tenYrsAgo: Bool, completion: @escaping ([String: Any]) -> Void) {
        
        let stringOfTickers = tickers.joined(separator: ",")
        
        var endDate = Date()
        if tenYrsAgo {
            endDate = endDate.advanced(by: -60*60*24*365*10) // move end date back 10 yrs
        }
        let endDateLessSevenDays = endDate.advanced(by: -60*60*24*7) // get the date 7 days earlier to make sure we get a day with a ticker price
        let endDateString = endDate.description.prefix(10) // get day 10 yrs ago as string
        let endDateLessSevenDaysString = endDateLessSevenDays.description.prefix(10) // get day 10 yrs ago as string
        
        let urlString = "https://api.unibit.ai/v2/stock/historical/?"
        let urlParametersTickers = "tickers=\(stringOfTickers)"
        let urlParametersDate = "&startDate=\(endDateLessSevenDaysString)&endDate=\(endDateString)"
        let urlParamtersKey = "&interval=1&dataType=json&accessKey=\(Secrets.unibitKey)"
        let url = URL(string: urlString + urlParametersTickers + urlParametersDate + urlParamtersKey)
        //print(url)
        if let url = url {
            var request = URLRequest(url: url)
            
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

            URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
                if let data = data {
                    
                    var tickersPricesDict:[String: Double] = [:]
                    
                    DispatchQueue.main.async {
                        do {
                            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: [String: Any]]
                            if let resultsDict = json?["result_data"] as [String: Any]? {
                                // resultsDict has tickers for keys and lots of data as value
                                for ticker in tickers {
                                    if let tickerDict = resultsDict[ticker] {
                                        let tickerDictArr = tickerDict as! [Any]
                                        let priceDict = tickerDictArr.last as! [String: Any]
                                        if let adj_close = priceDict["adj_close"] as! Double? {
                                            tickersPricesDict[ticker] = adj_close
                                        }
                                    }
                                }
                                completion(["results": tickersPricesDict])
                            } else {
                                completion(["error": ["error" : "no response"]])
                            }
                        } catch {
                            print("server not found")
                            completion(["error": ["server not found"]])
                        }
                    }
                }
                if let error = error {
                    completion(["message": error])
                }
            }).resume()
        } else {
            print("error: unable to unwrap url")
        }
    }
    
    class func extractValuesFromJSON(results: [Any]) -> [NSNumber]{
        // extract the values from the JSON, there should be 10 yrs of values, but sometimes there is less.
        var valuesFound = [NSNumber]()
        for resultForYear in results {
            if let unwrappedDict = resultForYear as? [String: Any] {
                if let unwrappedValue = unwrappedDict["value"] as! NSNumber?{
                    valuesFound.append(unwrappedValue)
                }
            }
        }
        return valuesFound
    }
    
    class func setSubjectiveStatus(question: String, status: String, equity: Equity, completion: @escaping (apiResponse) -> Void) {
        let urlString = "\(Secrets.apiURL)setSubjectiveStatus.php"
        let url = URL(string: urlString)
        if let url = url {
            var request = URLRequest(url: url)
        
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
            let parameterString = "ticker=\(equity.ticker)&question=\(question)&status=\(status)&key=\(Secrets.apiKey)"
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
    
    class func setSubjectiveAnswer(question: String, answer: String, equity: Equity, completion: @escaping (apiResponse) -> Void) {
        let urlString = "\(Secrets.apiURL)setSubjectiveAnswer.php"
        let url = URL(string: urlString)
        if let url = url {
            var request = URLRequest(url: url)
            
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
            var parameterString = String()
            if let answerUnwrapped = answer.addingPercentEncoding(withAllowedCharacters: .urlUserAllowed) {
                parameterString = "ticker=\(equity.ticker)&question=\(question)&answer=\(answerUnwrapped)&key=\(Secrets.apiKey)"
            }
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
                                    case "q1": equity.q1Answer = answer
                                    case "q2": equity.q2Answer = answer
                                    case "q3": equity.q3Answer = answer
                                    case "q4": equity.q4Answer = answer
                                    case "q5": equity.q5Answer = answer
                                    case "q6": equity.q6Answer = answer
                                    default: print("error 122")
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
                            
                                    let unwrappedNameFirst = unwrappedName.first
                                    let unwrappedTickerFirst = unwrappedTicker.first
                            
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
                                    
                                    
                                    let emptyTuple = ([String](),[Double]())

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
                                        
                                        ROEHistory: emptyTuple,
                                        EPSHistory: emptyTuple,
                                        BVHistory: emptyTuple,
                                        DRHistory: emptyTuple,
                                        SOHistory: emptyTuple,

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
    
    // get data for charts
    class func getMeasureValuesFromDB(ticker: String, measure: String, completion: @escaping (([String],[Double])) -> Void) {
        let store = DataStore.sharedInstance
        var historicalValues = (annualLabels: [String](), annualValues: [Double]())
        let urlString = "\(Secrets.apiURL)getMeasureValues.php"
        let url = URL(string: urlString)
        if let url = url {
            var request = URLRequest(url: url)
            
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
            let parameterString = "key=\(Secrets.apiKey)&ticker=\(ticker)&measure=\(measure)"
            request.httpBody = parameterString.data(using: .utf8)
            URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
                if let unwrappedData = data {
                    do {
                        let responseJSON = try JSONSerialization.jsonObject(with: unwrappedData, options: []) as AnyObject

                        // the chart needs two arrays as inputs so, create a tuple of arrays, one for labels and one for values
                        for index in 2006...2030 {
                            if responseJSON[String(index)] as? String != nil {
                                let labelForYearFull = String(index)
                                let labelForYearShort = labelForYearFull.suffix(2) //grab the last two chars in the year
                                let valueForYearString = responseJSON[String(index)] as! String
                                if let valueForYear = Double(valueForYearString) {
                                    historicalValues.annualLabels.append(String(labelForYearShort))
                                    historicalValues.annualValues.append(valueForYear)
                                }
                            }
                        }
                        // add the historicalValues to the dataStore
                        if let equity = store.getEquityByTickerFromStore(ticker: ticker) {
                            switch measure {
                            case "ReturnOnEquity":
                                equity.ROEHistory = historicalValues
                            case "EarningsPerShare":
                                equity.EPSHistory = historicalValues
                            case "BookValuePerShare":
                                equity.BVHistory = historicalValues
                            case "DebtEquity":
                                equity.DRHistory = historicalValues
                            case "Shares":
                                equity.SOHistory = historicalValues
                            default:
                                break
                            }
                        }
                        completion(historicalValues)
                    } catch {
                        // An error occurred when creating responseJSON
                        historicalValues = (annualLabels: ["error"], annualValues: [0.0])
                        completion(historicalValues)
                    }
                }
            }).resume()
        } else {
            print("error: unable to unwrap url")
        }
    }
    
//    class func fetchValues() {
//        print("fetchValues")
//        APIClient.requestHistoricalData(measure: "basiceps", ticker: "AAPL", completion: { response in
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
//
//    }
}

enum apiResponse {
    case authenticated
    case userNameInvalid
    case passwordInvalid
    case noReply
    case ok
    case failed
}
