//
//  CompaniesUIView.swift
//  EquityStatus
//
//  Created by Paul Tangen on 11/16/19.
//  Copyright © 2019 Paul Tangen. All rights reserved.
//

import UIKit
import SQLite

class CompaniesView: UIView, UITableViewDataSource, UITableViewDelegate {

    let companiesTableViewInst = UITableView()
    let dateFormatterGet = DateFormatter()
    
    // define companies table for use in table editing
    var companiesArr: [Company] = []
    // table
    let companiesTable = Table("companiesTable")
    let tickerCol = Expression<String>("tickerCol")
    let nameCol = Expression<String>("nameCol")
    let epsiCol = Expression<Int?>("epsiCol")
    let epsvCol = Expression<Double?>("epsvCol")
    let roeiCol = Expression<Int?>("roeiCol")
    
    override init(frame:CGRect){
        super.init(frame: frame)
        self.companiesTableViewInst.delegate = self
        self.companiesTableViewInst.dataSource = self
        self.companiesTableViewInst.register(tableViewCell.self, forCellReuseIdentifier: "prototype")
        self.companiesTableViewInst.separatorColor = UIColor.clear
        self.companiesTableViewInst.accessibilityLabel = "companiesTableViewInst"
        self.companiesTableViewInst.accessibilityIdentifier = "companiesTableViewInst"
        
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        
        //self.dropTables()
        //self.createTables()
        //self.insertCompanies()
        //self.insertRows(tickerVal: "AA", nameVal: "A_Name", fyEndMonthVal: 05)
        //self.runCommand()
        //self.renameColumn()
        //self.updateRows()
        
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
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.companiesArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 42
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewCell(style: .default, reuseIdentifier: "prototype")
        cell.selectionStyle = .none
        
        cell.textLabel?.text = self.companiesArr[indexPath.row].ticker
        cell.col2Label.text = self.companiesArr[indexPath.row].name
        if let epsi = self.companiesArr[indexPath.row].epsi {
            cell.col3Label.text = epsi.description
        }
        if let roei = self.companiesArr[indexPath.row].roei {
            cell.col4Label.text = roei.description
        }
        //cell.col3Label.text = String(self.companiesArr[indexPath.row].epsi)
        //cell.col4Label.text = String(self.companiesArr[indexPath.row].epsv)
        return cell
    }
    
    // doc: https://github.com/stephencelis/SQLite.swift/blob/master/Documentation/Index.md#updating-rows
    func getDBConnection() -> Connection {
        var database: Connection!
        // runs db connection, if file for DB does not exist, a file is created for the DB
        do {
            let doctumentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileurl = doctumentDirectory.appendingPathComponent("equityStatus").appendingPathExtension("sqlite3")
            database = try Connection(fileurl.path)
        } catch {
            print(error)
        }
        return database
    }
    
    func addCompanyTable(completion: @escaping (Bool) -> Void){
        print("addTables")
        let database = getDBConnection()
        
        // define table
        let addCompaniesTable = companiesTable.create{ (table) in
            table.column(tickerCol, primaryKey: true)
            table.column(nameCol)
            table.column(epsiCol)
            table.column(epsvCol)
            table.column(roeiCol)
        }
        
        do {
            try database.run(addCompaniesTable)
            // populate the companies table with ticker and name
            APIClient.requestCompanies(completion: { response in
                if let responseUnwrapped = response["message"]{
                    print("Message 3: \(responseUnwrapped)")
                }
                
                //let yearsAgo = Date().advanced(by: -1000000000)
               
                for companyFound in response["results"] as! [Any] {
                    let companyFoundDict = companyFound as! [String: String]
                    if let nameUnwrapped = companyFoundDict["name"], let tickerUnwrapped = companyFoundDict["ticker"] {
                        self.insertRows(ticker: tickerUnwrapped, name: nameUnwrapped, epsi: nil, epsv: nil, roei: nil)
                    }
                }
                completion(true)
            })
        } catch {
            print(error)
            completion(false)
        }
    }
    
    func insertRows(ticker: String, name: String, epsi: Int?, epsv: Double?, roei: Int?){
        //print("insertRows")
        let database = getDBConnection()
        
        // insert a row
        let sqlStatement = companiesTable.insert(tickerCol <- ticker, nameCol <- name)
        do {
            try database.run(sqlStatement)
        } catch {
            print(error)
        }
    }
    
    func updateMeasures(measure: String, completion: @escaping (Bool) -> Void){

        let myGroup = DispatchGroup() // used to determine for loop is complete

        for company in companiesArr {
            myGroup.enter()
            APIClient.requestEPS(ticker: company.ticker, measure: measure, completion: { response in
                if let epsArr = response["results"] as! [Double]? {
                    //print(epsArr)
//                    if (results as! String).isEqual("error") || (results as! String).isEqual("no data found") {
//                        print(results)
//                    } else {
                    //print("update rows")
                    let database = self.getDBConnection()
                    
                    let measureValue = self.getInterestRate(valuesArr: epsArr)
                    print("measure: \(measure), measureValue: \(measureValue)")

                    // where clause
                    let selectedTicker = self.companiesTable.filter(self.tickerCol == company.ticker)
                    do {
                        if measure == "epsi" {
                            try database.run(selectedTicker.update(self.epsiCol <- measureValue))
                        } else if measure == "roei" {
                            try database.run(selectedTicker.update(self.roeiCol <- measureValue))
                        }
                    } catch {
                        print(error)
                    }
                }
                myGroup.leave()
            })
        }

        myGroup.notify(queue: DispatchQueue.main, execute: {
            completion(true) // do select and update tableview
        })
    }

    func dropCompanyTable(completion: @escaping (Bool) -> Void){
        print("drop tables")
        let database = getDBConnection()
        
        do {
            try database.run(companiesTable.drop())
            self.companiesArr = []
            completion(true)
        } catch {
            print(error)
            completion(false)
        }
    }
    
    func updateRows(ticker: String, measure: String, value: Int){
        print("update rows")
        let database = getDBConnection()
        
        // where clause
        let updateName = companiesTable.filter(tickerCol == ticker)
        do {
            try database.run(updateName.update(epsiCol <- value))
        } catch {
            print(error)
        }
    }
    
    func getInterestRate(valuesArr: [Double]) -> Int {
        // formula: https://www.thecalculatorsite.com/articles/finance/compound-interest-formula.php
        // assumes 1 compounding period per year
        //var lastValue: Double
        var firstValueAdjusted: Double
        var lastValueAdjusted: Double
        var interestRatePercent: Int = 0
        
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
            
            //print("firstValueAdjusted: \(firstValueAdjusted), lastValueAdjusted: \(lastValueAdjusted)")
            
            let interestRateInner = firstValueAdjusted/lastValueAdjusted
            let interestRateExponent = 1 / Double(valuesArr.count/4) // data comes by quarter so divide by for to get annual rate
            let interestRate = (pow(interestRateInner, interestRateExponent)) - 1
            interestRatePercent = Int((interestRate * 100))
        }
        return interestRatePercent
    }
    
    func selectRows(completion: @escaping (Bool) -> Void) {
        print("selectRows")
        let database = getDBConnection()

        do {
            let companyRows = try database.prepare(companiesTable.order(tickerCol.asc))
            self.companiesArr.removeAll()
            for companyRow in companyRows {
                //print("ticker: \(companyRow[tickerCol]), name: \(companyRow[nameCol]), collectionDay: \(companyRow[collectionDayCol]) lastCollection: \(String(describing: companyRow[lastCollectionCol]))")
                

                let company = Company(ticker: companyRow[tickerCol], name: companyRow[nameCol])
                
                // set values for optional properties
                if let epsi = companyRow[epsiCol] {
                    company.epsi = epsi
                }
                
                if let epsv = companyRow[epsvCol] {
                    company.epsv = epsv
                }
                
                if let roei = companyRow[roeiCol] {
                    company.roei = roei
                }
                
                self.companiesArr.append(company)
            }
  
            completion(true)
        } catch {
            print(error)
            self.companiesArr.removeAll()
            completion(true)
        }
    }
}

