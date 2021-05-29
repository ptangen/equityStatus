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
    // Use the "Core US Fundamentals Data" at quandl. $50/mo
    class func requestHistoricalMeasures(tickers: String, completion: @escaping ([String: Any]) -> Void) {
        let urlString = "https://www.quandl.com/api/v3/datatables/SHARADAR/SF1.json"
        let urlWithParameters = "\(urlString)?dimension=MRY&qopts.columns=ticker,datekey,eps,sharesbas,de,pe1,roe,bvps&api_key=\(Secrets.quandlKey)&ticker=\(tickers)"
        let url = URL(string: urlWithParameters)
        if let url = url {
           
            var request = URLRequest(url: url)
            
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

            URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
                if let data = data {
                    DispatchQueue.main.async {
                        do {
                            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                            if let message = (json?["message"]) {
                                completion(["error": message as! String])
                            } else if let datatable = json?["datatable"] {
                                //dump(datatable)
                                if let datatableArr = datatable as? Dictionary<String, [AnyObject]>{
                                    if let data = datatableArr["data"] {
                                        //print(data)
                                        let formatter = DateFormatter()
                                        formatter.dateFormat = "yyyy-MM-dd"
                                        var historicalMeasures = [HistoricalMeasure]()
                                        
                                        for tickersData in data {
                                            let historicalMeasure = HistoricalMeasure(ticker: "inital value", date: Date())

                                            // ticker
                                            if let ticker = tickersData.allObjects?[0] as? String {
                                                historicalMeasure.ticker = ticker
                                            } else {
                                                historicalMeasure.ticker = "unable to unwrap"
                                            }
                                            // date
                                            if let dateString = tickersData.allObjects?[1] as? String {
                                                if let date = formatter.date(from: dateString) {
                                                    historicalMeasure.date = date
                                                }
                                            }
                                            // eps
                                            if let eps = tickersData.allObjects?[2] as? Double {
                                                historicalMeasure.eps = eps
                                            }
                                            // so
                                            if let so = tickersData.allObjects?[3] as? Int {
                                                historicalMeasure.so = so
                                            }
                                            // dr
                                            if let dr = tickersData.allObjects?[4] as? Double {
                                                historicalMeasure.dr = dr
                                            }
                                            // pe
                                            if let pe = tickersData.allObjects?[5] as? Double {
                                                historicalMeasure.pe = pe
                                            }
                                            // roe
                                            if let roe = tickersData.allObjects?[6] as? Double {
                                                historicalMeasure.roe = roe
                                            }
                                            // bv
                                            if let bv = tickersData.allObjects?[7] as? Double {
                                                historicalMeasure.bv = bv
                                            }
//                                            print("ticker: \(historicalMeasure.ticker)")
//                                            print("date: \(historicalMeasure.date)")
//                                            print("eps: \(historicalMeasure.eps)")
//                                            print("so: \(historicalMeasure.so)")
//                                            print("dr: \(historicalMeasure.dr)")
//                                            print("pe: \(historicalMeasure.pe)")
//                                            print("roe: \(historicalMeasure.roe)")
//                                            print("bv: \(historicalMeasure.bv)")
                                            
                                            historicalMeasures.append(historicalMeasure)
                                        }
                                        completion(["results": historicalMeasures])
                                    }
                                } else {
                                    completion(["error": "No values found for tickers. 6" as String])
                                }
                            } else {
                                completion(["error": "No values found for tickers. 3" as String])
                            }
                        } catch {
                            completion(["error": "The request for measures failed. 4"])
                        }
                    }
                }
                if let error = error {
                    dump(error)
                    completion(["error": "error"])
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
                                            if let priceDict = tickerDictArr.last as? [String: Any]{
                                                if let adj_close = priceDict["adj_close"] as! Double? {
                                                    tickersPricesDict[ticker] = adj_close
                                                }
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
