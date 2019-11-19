//
//  CompaniesUIView.swift
//  EquityStatus
//
//  Created by Paul Tangen on 11/16/19.
//  Copyright © 2019 Paul Tangen. All rights reserved.
//

import UIKit
import SQLite
import CoreData

class CompaniesView: UIView, UITableViewDataSource, UITableViewDelegate {

    let companiesTableViewInst = UITableView()
    
    // define companies table for use in table editing
    var companiesArr: [Company] = []
    let companies = Table("companies")
    let ticker = Expression<String>("ticker")
    let name = Expression<String>("name")
    let fyEndMonth = Expression<Int>("fyEndMonth")
    
    override init(frame:CGRect){
        super.init(frame: frame)
        self.accessibilityLabel = "evaluationViewInst"
        self.companiesTableViewInst.delegate = self
        self.companiesTableViewInst.dataSource = self
        self.companiesTableViewInst.register(CompaniesTableViewCell.self, forCellReuseIdentifier: "prototype")
        self.companiesTableViewInst.separatorColor = UIColor.clear
        self.companiesTableViewInst.accessibilityLabel = "companiesTableViewInst"
        self.companiesTableViewInst.accessibilityIdentifier = "companiesTableViewInst"
        
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
        let cell = CompaniesTableViewCell(style: .default, reuseIdentifier: "prototype")
        cell.selectionStyle = .none
        cell.textLabel?.text = self.companiesArr[indexPath.row].ticker
        cell.nameLabel.text = self.companiesArr[indexPath.row].name
        cell.monthLabel.text = String(self.companiesArr[indexPath.row].fyEndMonth)
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
    
    func addTables(completion: @escaping (Bool) -> Void){
        print("addTables")
        let database = getDBConnection()
        
        // define table
        let addCompaniesTable = companies.create{ (table) in
            table.column(ticker, primaryKey: true)
            table.column(name)
            table.column(fyEndMonth)
        }
        
        do {
            try database.run(addCompaniesTable)
            // populate the companies table
            APIClient.requestCompanies(completion: { response in
                if let responseUnwrapped = response["message"]{
                    print("Message 3: \(responseUnwrapped)")
                }
               
                for companyFound in response["results"] as! [Any] {
                    let companyFoundDict = companyFound as! [String: String]
                    if let nameUnwrapped = companyFoundDict["name"], let tickerUnwrapped = companyFoundDict["ticker"] {
                        self.insertRows(tickerVal: tickerUnwrapped, nameVal: nameUnwrapped, fyEndMonthVal: 00)
                    }
                }
                completion(true)
            })
        } catch {
            print(error)
            completion(false)
        }
    }
    
    func insertRows(tickerVal: String, nameVal: String, fyEndMonthVal: Int){
        //print("insert completed")
        let database = getDBConnection()
        
        // insert a row
        let sqlStatement = companies.insert(ticker <- tickerVal, name <- nameVal, fyEndMonth <- fyEndMonthVal)
        do {
            try database.run(sqlStatement)
        } catch {
            print(error)
        }
    }
    
    func dropTables(completion: @escaping (Bool) -> Void){
        print("drop tables")
        let database = getDBConnection()
        
        do {
            try database.run(companies.drop())
            self.companiesArr = []
            completion(true)
        } catch {
            print(error)
            completion(false)
        }
    }
    
    func updateRows(){
        print("update rows")
        let database = getDBConnection()
        
        // where clause
        let updateName = companies.filter(name == "B_Name")
        do {
            try database.run(updateName.update(ticker <- "BB"))
        } catch {
            print(error)
        }
    }
    
    func selectRows(completion: @escaping (Bool) -> Void) {
        print("selectRows")
        let database = getDBConnection()

        do {
            let companyRows = try database.prepare(companies.order(ticker.asc))
            self.companiesArr.removeAll()
            for company in companyRows {
                //print("ticker: \(company[ticker]), name: \(company[name]), fyEndMonth: \(String(describing: company[fyEndMonth]))")
                
                let companyInst = Company(ticker: company[ticker], name: company[name], fyEndMonth: Int(company[fyEndMonth]))
                self.companiesArr.append(companyInst)
            }
            completion(true)
        } catch {
            print(error)
            self.companiesArr.removeAll()
            completion(true)
        }
    }
}

