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
                            } else if let measureArr = json?["historical_data"] {
                                var measureValues = [Double]()
                                if let measureArrUnwrapped = measureArr as? [[String: Any?]] {
                                    for eps in measureArrUnwrapped {
                                        if let measureValue = (eps["value"]) {
                                            if measureValues.count < 40 {
                                                // collect values for the most recent 40 quarters
                                                //print("\(ticker) , value to append: \(String(describing: measureValue))")
                                                if let measureArrUnwrapped = measureValue as! Double? {
                                                    measureValues.append(measureArrUnwrapped)
                                                } else {
                                                    break // a nil value was found in the dataset so exit ignoring the later values
                                                }
                                            }
                                        } else {
                                            completion(["error": "No values for \(ticker)." as String])
                                        }
                                    }
                                } else {
                                    completion(["error": "No values for \(ticker)." as String])
                                }
                                if measureValues.count > 20 {
                                    completion(["results": measureValues])
                                } else {
                                    completion(["error": "\(ticker): > 5 yrs of data. Discarded." as String])
                                }
                            } else {
                                completion(["error": "No values for \(ticker)." as String])
                            }
                        } catch {
                            completion(["error": "The request for \(ticker) failed. Try again."])
                        }
                    }
                }
                if let error = error {
                    completion(["error": error])
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
            // for 12.1 iOS: endDate = Calendar.current.date(byAdding: .month, value: -120, to: Date())!
        }
        
        // had to comment out for iOS 12 TODO: remove setting endDateLessSevenDays below
        let endDateLessSevenDays = endDate.advanced(by: -60*60*24*7) // get the date 7 days earlier to make sure we get a day with a ticker price
        // for 12.1 iOS: var endDateLessSevenDays = Date()
        // for 12.1 iOS: endDateLessSevenDays = Calendar.current.date(byAdding: .month, value: -121, to: Date())!
        
        
        let endDateString = endDate.description.prefix(10) // get day 10 yrs ago as string
        let endDateLessSevenDaysString = endDateLessSevenDays.description.prefix(10) // get day 10 yrs ago as string
        
        let urlString = "https://api.unibit.ai/v2/stock/historical/?"
        let urlParametersTickers = "tickers=\(stringOfTickers)"
        let urlParametersDate = "&startDate=\(endDateLessSevenDaysString)&endDate=\(endDateString)"
        let urlParamtersKey = "&interval=1&dataType=json&accessKey=\(Secrets.unibitKey)"
        let url = URL(string: urlString + urlParametersTickers + urlParametersDate + urlParamtersKey)
        print(url)
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
                            // on error, the data has a different structure, so must unwrap is differently
                            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]

                            if let status = json?["status"] as! Int? {
                                if status != 200 {
                                    // error due to exceeding quota or price does not exist for at time period provided
                                    if let message = json?["message"] as! String? {
                                        completion(["error": message])
                                    }
                                }
                            } else {
                                // status is not return on successful requests
                                if let resultsDict = json?["result_data"] as! [String: Any]? {
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
                                }
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
}
