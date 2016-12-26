//
//  AnalysisView.swift
//  EquityStatus
//
//  Created by Paul Tangen on 12/19/16.
//  Copyright © 2016 Paul Tangen. All rights reserved.
//

import UIKit

class AnalysisView: UIView, UITableViewDataSource, UITableViewDelegate {

    let tableViewInst = UITableView()
    let subTitle: UILabel = UILabel()
    let myArray = ["one", "two", "three", "four"]
    
    override init(frame:CGRect){
        super.init(frame: frame)
        self.tableViewInst.delegate = self
        self.tableViewInst.dataSource = self
        self.tableViewInst.register(AnalysisTableViewCell.self, forCellReuseIdentifier: "listCell")
        //self.tableViewInst.estimatedRowHeight = 120
        self.pageLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func pageLayout() {
        // subtitle
        self.addSubview(self.subTitle)
        self.subTitle.translatesAutoresizingMaskIntoConstraints = false
        self.subTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 80).isActive = true
        self.subTitle.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        self.subTitle.text = "Evaluate qualitative measures."
        self.subTitle.font = UIFont(name: Constants.appFont.regular.rawValue, size: Constants.fontSize.small.rawValue)
        
        self.addSubview(self.tableViewInst)
        self.tableViewInst.translatesAutoresizingMaskIntoConstraints = false
        self.tableViewInst.topAnchor.constraint(equalTo: self.subTitle.bottomAnchor, constant: 20).isActive = true
        self.tableViewInst.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 80).isActive = true
        self.tableViewInst.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        self.tableViewInst.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 56
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = AnalysisTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "listCell")
        
        //cell.selectionStyle = .none
        cell.textLabel?.text = self.myArray[indexPath.row]
        cell.textLabel?.font = UIFont(name: Constants.appFont.regular.rawValue, size: Constants.fontSize.medium.rawValue)
        
        return cell
    }


}
