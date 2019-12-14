//
//  DataCollection.swift
//  EquityStatus
//
//  Created by Paul Tangen on 11/16/19.
//  Copyright © 2019 Paul Tangen. All rights reserved.
//

import UIKit
import SQLite

protocol DataCollectionViewDelegate: class {
    func showAlertMessage(_: String)
}

class DataCollectionView: UIView, UITableViewDataSource, UITableViewDelegate {

    weak var delegate: DataCollectionViewDelegate?
    let store = DataStore.sharedInstance
    let companiesTableViewInst = UITableView()
    let activityIndicator = UIView()
    var errorMessage = String()
    
    // define companies table for use in table editing
    // db table
    let companiesTable =    Table("companiesTable")
    
    let tickerCol =         Expression<String>("tickerCol")
    let nameCol =           Expression<String>("nameCol")
    let eps_iCol =          Expression<Int?>("eps_iCol")
    let eps_sdCol =         Expression<Double?>("eps_sdCol")
    let eps_lastCol =       Expression<Double?>("eps_lastCol")
    let roe_avgCol =        Expression<Int?>("roe_avgCol")
    let bv_iCol =           Expression<Int?>("bv_iCol")
    let so_reducedCol =     Expression<Int?>("so_reducedCol")
    let dr_avgCol =         Expression<Int?>("dr_avgCol")
    let pe_avgCol =         Expression<Double?>("pe_avgCol")
    let price_lastCol =     Expression<Double?>("price_lastCol")
    let previous_roiCol =   Expression<Int?>("previous_roiCol")
    let expected_roiCol =   Expression<Int?>("expected_roiCol")
    
    let q1_answerCol =   Expression<String?>("q1_answerCol")
    let q2_answerCol =   Expression<String?>("q2_answerCol")
    let q3_answerCol =   Expression<String?>("q3_answerCol")
    let q4_answerCol =   Expression<String?>("q4_answerCol")
    let q5_answerCol =   Expression<String?>("q5_answerCol")
    let q6_answerCol =   Expression<String?>("q6_answerCol")
    
    let q1_passedCol =   Expression<Bool?>("q1_passedCol")
    let q2_passedCol =   Expression<Bool?>("q2_passedCol")
    let q3_passedCol =   Expression<Bool?>("q3_passedCol")
    let q4_passedCol =   Expression<Bool?>("q4_passedCol")
    let q5_passedCol =   Expression<Bool?>("q5_passedCol")
    let q6_passedCol =   Expression<Bool?>("q6_passedCol")
    
    override init(frame:CGRect){
        super.init(frame: frame)
        self.companiesTableViewInst.delegate = self
        self.companiesTableViewInst.dataSource = self
        self.companiesTableViewInst.register(DataCollectionTableViewCell.self, forCellReuseIdentifier: "prototype")
        self.companiesTableViewInst.separatorColor = UIColor.clear
        
        // select the rows and update the table
        self.selectRows() {isSuccessful in
            if isSuccessful {
                self.pageLayout()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func pageLayout() {
       
        // evaluationTableViewInst
        self.addSubview(self.companiesTableViewInst)
        self.companiesTableViewInst.translatesAutoresizingMaskIntoConstraints = false
        self.companiesTableViewInst.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        self.companiesTableViewInst.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -50).isActive = true
        self.companiesTableViewInst.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        self.companiesTableViewInst.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        
        // activityIndicator
        self.addSubview(self.activityIndicator)
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.activityIndicator.heightAnchor.constraint(equalToConstant: 80).isActive = true
        self.activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.activityIndicator.widthAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.store.companies.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = DataCollectionTableViewCell(style: .default, reuseIdentifier: "prototype")
        cell.selectionStyle = .none
        
        cell.textLabel?.text = self.store.companies[indexPath.row].ticker
        cell.nameLabel.text = self.store.companies[indexPath.row].name
        
        // previous_roiLabel
        if let previous_roi = self.store.companies[indexPath.row].previous_roi {
            cell.previous_roiLabel.text = previous_roi.description
        }
        
        // expected_roiLabel
        if let expected_roi = self.store.companies[indexPath.row].expected_roi {
            cell.expected_roiLabel.text = expected_roi.description
        }
        
        // eps_iLabel
        if let eps_i = self.store.companies[indexPath.row].eps_i {
            cell.eps_iLabel.text = "eps_i: \(eps_i.description)"
        }
        
        // eps_sdLabel
        if let eps_sd = self.store.companies[indexPath.row].eps_sd {
            cell.eps_sdLabel.text = "eps_sd: \(String(format:"%.1f", eps_sd))"
        }
        
        // roe_avgLabel
        if let roe_avg = self.store.companies[indexPath.row].roe_avg {
            cell.roe_avgLabel.text = "roe_avg: \(roe_avg.description)"
        }
        
        // bv_iLabel
        if let bv_i = self.store.companies[indexPath.row].bv_i {
            cell.bv_iLabel.text = "bv_i: \(bv_i.description)"
        }
        
        // dr_avgLabel
        if let dr_avg = self.store.companies[indexPath.row].dr_avg {
            cell.dr_avgLabel.text = "dr_avg: \(dr_avg.description)"
        }
        
        // so_reducedLabel
        if let so_reduced = self.store.companies[indexPath.row].so_reduced {
            cell.so_reducedLabel.text = "so_reduced: \(so_reduced.description)"
        }
        
        return cell
    }
    
    func updateMeasures(measure: String, completion: @escaping (Bool) -> Void){
        let database = DBUtilities.getDBConnection()
        let myGroup = DispatchGroup() // used to determine for loop is complete
        
        var tickersToGetMeasureValue = [String]()
        var tickersToRemoveMeasureValue = [String]()
        for company in self.store.companies {
            if measure == "eps_i" {
                tickersToGetMeasureValue.append(company.ticker) // get eps for calculation of eps_i and eps_sd from all tickers
            } else {
                // if measure == roe_avg, bv_i, so_reduced, dr_avg, pe_avg then collect values when eps_i and eps_ds pass threshhold
                // if these eps_i or eps_sd do nnot meet the thresholds, then clear the value in the DB for the selected measure
                if let eps_i_passed_unwrapped = company.eps_i_passed, let eps_sd_passed_unwrapped = company.eps_sd_passed {
                    if eps_i_passed_unwrapped && eps_sd_passed_unwrapped {
                        tickersToGetMeasureValue.append(company.ticker) // all measure values met threshold
                    } else {
                        tickersToRemoveMeasureValue.append(company.ticker) // measure value did not met threshold
                    }
                }
            }
        }
        //print("tickersToGetMeasureValue: \(tickersToGetMeasureValue)")
        //print("tickersToRemoveMeasureValue: \(tickersToRemoveMeasureValue)")
        
        let timeToDelayForAPI: Double = 0.02
        var currentDelayForAPI: Double = 0

        for ticker in tickersToGetMeasureValue {
            myGroup.enter()
            currentDelayForAPI += timeToDelayForAPI
            queueRequestWithDelay(seconds: currentDelayForAPI) {
                APIClient.requestHistoricalData(ticker: ticker, measure: measure, completion: { response in
                    //print("response:  \(response)")
                    if let errorMessage = response["error"] as! String? {
                        if errorMessage != "An error occured. Please contact success@intrinio.com with the details."{ // this occurs when ticker not found, happens often with sandbox key
                            self.errorMessage += "\(errorMessage)\r\n" // show after collecting data
                        }
                    } else if let measureValueArr = response["results"] as! [Double]? {
                        // where clause
                        let selectedTicker = self.companiesTable.filter(self.tickerCol == ticker)
                        do {
                            switch measure {
                                
                                case "eps_i":
                                    let measureValuei = self.getInterestRate(valuesArr: measureValueArr)
                                    let measureValueSD = self.getSD(valuesArr: measureValueArr)
                                    //print("ticker: \(ticker), measureValuei: \(measure), measureValuei: \(measureValuei)")
                                    try database.run(selectedTicker.update(self.eps_iCol <- measureValuei))
                                    try database.run(selectedTicker.update(self.eps_sdCol <- measureValueSD))
                                    try database.run(selectedTicker.update(self.eps_lastCol <- measureValueArr.first))
                                case "roe_avg":
                                    let measureValue = self.getAverage(valuesArr: measureValueArr, multiplier: 100)
                                    //print("ticker: \(ticker), roe_avg: \(measureValue)")
                                    try database.run(selectedTicker.update(self.roe_avgCol <- Int(measureValue)))
                                case "bv_i":
                                    let measureValuei = self.getInterestRate(valuesArr: measureValueArr)
                                    try database.run(selectedTicker.update(self.bv_iCol <- measureValuei))
                                case "so_reduced":
                                    let measureValue = self.getAmountReduced(valuesArr: measureValueArr)
                                    try database.run(selectedTicker.update(self.so_reducedCol <- measureValue))
                                case "dr_avg":
                                    let measureValue = self.getAverage(valuesArr: measureValueArr, multiplier: 1)
                                    try database.run(selectedTicker.update(self.dr_avgCol <- Int(measureValue)))
                                case "pe_avg":
                                    let measureValue = self.getAverage(valuesArr: measureValueArr, multiplier: 1)
                                    try database.run(selectedTicker.update(self.pe_avgCol <- measureValue))
                                default :
                                  print("measure invalid")
                            }
                        } catch {
                            print(error)
                        }
                    }
                    myGroup.leave()
                })
            }
        }
        
        let valuesRemovedCompleted = self.removeValuesForMeasure(tickersToRemoveMeasureValue: tickersToRemoveMeasureValue, measure: measure)
        //print("valuesRemovedCompleted: \(valuesRemovedCompleted)")

        myGroup.notify(queue: DispatchQueue.main, execute: {
            if(self.errorMessage.count > 0){
                self.delegate?.showAlertMessage(self.errorMessage)
                self.errorMessage = ""
            }
            completion(true) // do select and update tableview
        })
    }
    
    func updateROI(measure: String, completion: @escaping (Bool) -> Void){
        // type is expected_roi or previous_roi

        let database = DBUtilities.getDBConnection()
        
        // create arrays of tickers, one array to collect data for and one array where thresholds are not met and remove data for the measure
        var tickersToGetMeasureValue = [String]()
        var tickersToRemoveMeasureValue = [String]()
        
        for company in self.store.companies{
            // filter out tickers with measures that did not pass
            if let eps_i_passed_unwrapped = company.eps_i_passed,
                let eps_sd_passed_unwrapped = company.eps_sd_passed,
                let roe_avg_passed_unwrapped = company.roe_avg_passed,
                let bv_i_passed_unwrapped = company.bv_i_passed,
                let dr_avg_passed_unwrapped = company.dr_avg_passed,
                let so_reduced_passed_unwrapped = company.so_reduced_passed {
                if eps_i_passed_unwrapped && eps_sd_passed_unwrapped && roe_avg_passed_unwrapped && bv_i_passed_unwrapped && dr_avg_passed_unwrapped && so_reduced_passed_unwrapped {
                    tickersToGetMeasureValue.append(company.ticker) // all measure values met threshold
                } else {
                    tickersToRemoveMeasureValue.append(company.ticker) // measure value did not met threshold
                }
            } else {
                tickersToRemoveMeasureValue.append(company.ticker) // one measure value was missing
            }
        }
        //print("tickersToGetMeasureValue: \(tickersToGetMeasureValue)")
        //print("tickersToRemoveMeasureValue: \(tickersToRemoveMeasureValue)")
        var tenYrsAgo = Bool()
        if measure == "expected_roi" {
            tenYrsAgo = false
        } else {
            tenYrsAgo = true
        }
        
        // fetch stock prices for the set of tickers - limit of 50 tickers
        if(tickersToGetMeasureValue.count > 0) {
            APIClient.getStockPrices(tickers: tickersToGetMeasureValue, tenYrsAgo: tenYrsAgo, completion: { response in
                if let responseUnwrapped = response["error"]{
                    let message = responseUnwrapped as! [String:String]
                    if let errorMessage = message["error"] {
                        print("Message : \(errorMessage), this happens when quota exceeded.")
                        self.delegate?.showAlertMessage(errorMessage + ", this happens when quota exceeded.")
                    }
                    
                    // insert some values for roi when quota exceeded
//                    let selectedTicker = self.companiesTable.filter(self.tickerCol == "AXP")
//                    do {
//                        try database.run(selectedTicker.update(self.previous_roiCol <- 100))
//                        try database.run(selectedTicker.update(self.expected_roiCol <- 100))
//                        // try database.run(selectedTicker.update(self.eps_iCol <- 100))
//                    } catch {
//                        print(error)
//                    }
                } else if let pricesDict = response["results"] as! [String: Double]?{
                    //print(pricesDict)
                    for ticker in tickersToGetMeasureValue {
                        
                        // where clause
                        let selectedTicker = self.companiesTable.filter(self.tickerCol == ticker)
                        do {
                            if tenYrsAgo { // calc previous_roi
                                
                                if let company = self.store.companies.first(where: {$0.ticker == ticker}){
                                    // get previous roi from them the current price and price 10 yrs ago
                                    // if the current price doesnt exist, send the price from 10 yrs ago which will result in an roi of 0
                                    
                                    var measureValue: Int
                                    if let price_last = company.price_last {
                                        // interest rate function expects 10 yrs of values by quarter so create an array that looks like that
                                        var valuesArr = [Double](repeating: 0, count: 40)
                                        print("ticker: \(ticker), price_last: \(price_last)")
                                        valuesArr[0] = price_last
                                        valuesArr[39] = pricesDict[ticker]!
                                        measureValue = self.getInterestRate(valuesArr: valuesArr)
                                        
                                    } else {
                                        measureValue = 1 // should be 0  // we dont have current stock price so set measureValue to 0
                                    }
                                    try database.run(selectedTicker.update(self.previous_roiCol <- Int(measureValue)))
                                }
                            } else { // calc expected roi
                                // 1. put p/e avg in companiesArr - separate command
                                // 2. calc eps_in10yrs = eps_last * eps_i from value in companiesArr
                                // 3. calc price_in10yrs = eps_in10yrs * pe_avg
                                // 4. get price_last from pricesDict
                                // 5. calc expected_roi = getInterestRate([price_in10yrs, 0,0,0, price_current])
                                // 6. update expected_roi in DB
                                // 7. update price_last in db for use in previous_roi calc
                                
                                var price_in10yrs: Double
                                var measureValue: Int
                                if let company = self.store.companies.first(where: {$0.ticker == ticker}){
                                    
                                    var eps_in10yrs: Double
                                    if let eps_last = company.eps_last, let eps_i = company.eps_i{
                                        eps_in10yrs = eps_last * Double(eps_i)
                                    } else {
                                        eps_in10yrs = 0
                                    }
                                    print("ticker: \(ticker), eps_in10yrs: \(eps_in10yrs)")
                                    
                                    if let pe_avg = company.pe_avg {
                                        price_in10yrs = eps_in10yrs * pe_avg
                                    } else {
                                        price_in10yrs = 0
                                    }
                                    print("ticker: \(ticker), price_in10yrs: \(price_in10yrs)")
                                    
                                    // calc expected_roi
                                    var valuesArr = [Double](repeating: 0, count: 40)
                                    valuesArr[0] = price_in10yrs
                                    valuesArr[39] = pricesDict[ticker]!
                                    measureValue = self.getInterestRate(valuesArr: valuesArr)
                                    //print("ticker: \(ticker), expected_roi: \(measureValue)")
                                    
                                    // update DB
                                    try database.run(selectedTicker.update(self.expected_roiCol <- measureValue)) //  // int rate is positive
                                    try database.run(selectedTicker.update(self.price_lastCol <- pricesDict[ticker]))
                                } else {
                                    // company not found, update DB
                                    try database.run(selectedTicker.update(self.expected_roiCol <- nil))
                                    try database.run(selectedTicker.update(self.price_lastCol <- pricesDict[ticker]))
                                }
                            }
                        } catch {
                            print(error)
                        }
                    }
                }
                // set expected_roi/previous_roi value to empty if the company if filtered out for not meeting a threshold
                self.removeValuesForMeasure(tickersToRemoveMeasureValue: tickersToRemoveMeasureValue, measure: measure)
                completion(true)
            })
        } else {
            // set expected_roi/previous_roi value to empty if the company if filtered out for not meeting a threshold
            self.removeValuesForMeasure(tickersToRemoveMeasureValue: tickersToRemoveMeasureValue, measure: measure)
            completion(true)
        }
    }
    
    func removeValuesForMeasure(tickersToRemoveMeasureValue: [String], measure: String) {
        // when a ticker is filtered out for a calculation due to not meeting the threshold value for one measure, remove the value for the current measure

        let database = DBUtilities.getDBConnection()
        for ticker in tickersToRemoveMeasureValue {
            // where clause
            let selectedTicker = self.companiesTable.filter(self.tickerCol == ticker)
            do {
                switch measure {
                    
                    case "roe_avg":
                         try database.run(selectedTicker.update(self.roe_avgCol <- nil))
                    
                    case "bv_i":
                         try database.run(selectedTicker.update(self.bv_iCol <- nil))
                    
                     case "so_reduced":
                         try database.run(selectedTicker.update(self.so_reducedCol <- nil))
                    
                     case "dr_avg":
                         try database.run(selectedTicker.update(self.dr_avgCol <- nil))
                    
                     case "pe_avg":
                         try database.run(selectedTicker.update(self.pe_avgCol <- nil))
                    
                    case "expected_roi":
                        try database.run(selectedTicker.update(self.expected_roiCol <- nil))
                    
                    case "previous_roi":
                        try database.run(selectedTicker.update(self.previous_roiCol <- nil))
                    
                    default:
                        print("no measure found")
                }
                
            } catch {
                print(error)
            }
        }
     }

    func getAverage(valuesArr: [Double], multiplier: Int) -> Double {
        var sum: Double = 0
        for value in valuesArr {
            sum += value * Double(multiplier)
        }
        return sum/Double(valuesArr.count)
    }
    
    func getSD(valuesArr: [Double]) -> Double {
        let expression = NSExpression(forFunction: "stddev:", arguments: [NSExpression(forConstantValue: valuesArr)])
        if let standardDeviation = expression.expressionValue(with: nil, context: nil){
            return standardDeviation as! Double
        }
        return 0
    }
    
    func getAmountReduced(valuesArr: [Double]) -> Int {
        return Int(valuesArr.last! - valuesArr.first!)
    }
    
    func getInterestRate(valuesArr: [Double]) -> Int {
        // formula: https://www.thecalculatorsite.com/articles/finance/compound-interest-formula.php
        // assumes 1 compounding period per year
        //var lastValue: Double
        var firstValueAdjusted: Double
        var lastValueAdjusted: Double
        var interestRatePercent: Int = 0
        
        //print("valuesArr: \(valuesArr)")
        
        // the last value is the initial value in the interest rate calculation, this value cannot be
        // negative. As a result, any negative value is converted into 0.1 here
        // the first value also has to be positive and greater than or equal to the last value
        if let firstValue = valuesArr.first, let lastValue = valuesArr.last {
            
            if lastValue.isNaN || lastValue < 0{
                lastValueAdjusted = 0.1
            } else {
                lastValueAdjusted = lastValue
            }
            
            if firstValue.isNaN {
                firstValueAdjusted = 0.2
            } else if firstValue < lastValueAdjusted {
                return -1
            } else {
                firstValueAdjusted = firstValue
            }
            // print("firstValueAdjusted: \(firstValueAdjusted), lastValueAdjusted: \(lastValueAdjusted)")
            
            let interestRateInner = firstValueAdjusted/lastValueAdjusted
            //print("interestRateInner: \(interestRateInner)")
            let interestRateExponent = 1 / Double(valuesArr.count/4) // data comes by quarter so divide by for to get annual rate
            //print("interestRateExponent: \(interestRateExponent)")
            let interestRate = (pow(interestRateInner, interestRateExponent)) - 1
            //print("interestRate:  \(interestRate)")
            interestRatePercent = Int((interestRate * 100))
        }
        return interestRatePercent
    }
    
    func selectRows(completion: @escaping (Bool) -> Void) {
        let database = DBUtilities.getDBConnection()

        do {
            let companyRows = try database.prepare(companiesTable.order(tickerCol.asc))
            self.store.companies.removeAll()
            for companyRow in companyRows {
                
                let company = Company(ticker: companyRow[tickerCol], name: companyRow[nameCol])
                
                // set values in the coompany object for optional properties
                if let eps_i = companyRow[eps_iCol]                 { company.eps_i = eps_i }
                if let eps_sd = companyRow[eps_sdCol]               { company.eps_sd = eps_sd }
                if let eps_last = companyRow[eps_lastCol]           { company.eps_last = eps_last }
                if let roe_avg = companyRow[roe_avgCol]             { company.roe_avg = roe_avg }
                if let bv_i = companyRow[bv_iCol]                   { company.bv_i = bv_i }
                if let so_reduced = companyRow[so_reducedCol]       { company.so_reduced = so_reduced }
                if let dr_avg = companyRow[dr_avgCol]               { company.dr_avg = dr_avg }
                if let pe_avg = companyRow[pe_avgCol]               { company.pe_avg = pe_avg }
                if let price_last = companyRow[price_lastCol]       { company.price_last = price_last }
                if let previous_roi = companyRow[previous_roiCol]   { company.previous_roi = previous_roi }
                if let expected_roi = companyRow[expected_roiCol]   { company.expected_roi = expected_roi }
                
                if let q1_answer = companyRow[q1_answerCol]   { company.q1_answer = q1_answer }
                if let q2_answer = companyRow[q2_answerCol]   { company.q2_answer = q2_answer }
                if let q3_answer = companyRow[q3_answerCol]   { company.q3_answer = q3_answer }
                if let q4_answer = companyRow[q4_answerCol]   { company.q4_answer = q4_answer }
                if let q5_answer = companyRow[q5_answerCol]   { company.q5_answer = q5_answer }
                if let q6_answer = companyRow[q6_answerCol]   { company.q6_answer = q6_answer }
                
                if let q1_passed = companyRow[q1_passedCol]   { company.q1_passed = q1_passed }
                if let q2_passed = companyRow[q2_passedCol]   { company.q2_passed = q2_passed }
                if let q3_passed = companyRow[q3_passedCol]   { company.q3_passed = q3_passed }
                if let q4_passed = companyRow[q4_passedCol]   { company.q4_passed = q4_passed }
                if let q5_passed = companyRow[q5_passedCol]   { company.q5_passed = q5_passed }
                if let q6_passed = companyRow[q6_passedCol]   { company.q6_passed = q6_passed }
                
                self.store.companies.append(company)
                
            }
            
//            let companiesEvaluate = self.store.companies.filter({$0.ticker == "AA"})
//            for companyEvaluate in companiesEvaluate {
//                print("companyEvaluate: q1: \(companyEvaluate.q1_passed), q2: \(companyEvaluate.q2_passed), q3: \(companyEvaluate.q3_passed), q4: \(companyEvaluate.q4_passed), q5: \(companyEvaluate.q5_passed), q6: \(companyEvaluate.q6_passed), \(companyEvaluate.previous_roi_passed), \(companyEvaluate.expected_roi_passed), \(companyEvaluate.tab) ")
//            }
  
            completion(true)
        } catch {
            // no database found
            print(error)
            self.store.companies.removeAll()
            completion(true)
        }
    }
    
    func insertRows(database: Connection, ticker: String, name: String, epsi: Int?, epsv: Double?, roei: Int?){
        //print("insertRows")
        let sqlStatement = companiesTable.insert(tickerCol <- ticker, nameCol <- name)
        do {
            try database.run(sqlStatement)
        } catch {
            print(error)
        }
    }
    
    func addCompanyTable(completion: @escaping (Bool) -> Void){
       print("addTables")
       let database = DBUtilities.getDBConnection()
       
       // define table
       let addCompaniesTable = companiesTable.create{ (table) in
            table.column(tickerCol, primaryKey: true)
            table.column(nameCol)
            table.column(eps_iCol)
            table.column(eps_sdCol)
            table.column(eps_lastCol)
            table.column(roe_avgCol)
            table.column(bv_iCol)
            table.column(so_reducedCol)
            table.column(dr_avgCol)
            table.column(pe_avgCol)
            table.column(price_lastCol)
            table.column(previous_roiCol)
            table.column(expected_roiCol)
        
            table.column(q1_answerCol)
            table.column(q2_answerCol)
            table.column(q3_answerCol)
            table.column(q4_answerCol)
            table.column(q5_answerCol)
            table.column(q6_answerCol)
        
            table.column(q1_passedCol)
            table.column(q2_passedCol)
            table.column(q3_passedCol)
            table.column(q4_passedCol)
            table.column(q5_passedCol)
            table.column(q6_passedCol)
       }
       
       do {
           try database.run(addCompaniesTable)
           let database = DBUtilities.getDBConnection()
           let companyList = CompanyList()
           for companyTickerAndName in companyList.companyTickersAndNames {
               // the ticker is the key, name is the valueni
               self.insertRows(database: database, ticker: companyTickerAndName.key, name: companyTickerAndName.value, epsi: nil, epsv: nil, roei: nil)
           }
           completion(true)
           
       } catch {
           print(error)
           completion(false)
       }
   }
      
    func dropCompanyTable(completion: @escaping (Bool) -> Void){
        print("drop table")
        let database = DBUtilities.getDBConnection()
        
        do {
            try database.run(companiesTable.drop())
            DBUtilities.removeDBFile() // only one table, so remove the db file
            self.store.companies = []
            completion(true)
        } catch {
            print(error)
            completion(false)
        }
    }
    
    func queueRequestWithDelay(seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
    
    func showActivityIndicator(uiView: UIView) {
        self.activityIndicator.backgroundColor = UIColor(named: .blue)
        self.activityIndicator.layer.cornerRadius = 10
        self.activityIndicator.clipsToBounds = true
        
        let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        actInd.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        actInd.style = UIActivityIndicatorView.Style.whiteLarge
        actInd.center = CGPoint(x: 40, y: 40)
        
        self.activityIndicator.addSubview(actInd)
        actInd.startAnimating()
    }
}

