//
//  WatchView.swift
//  EquityStatus
//
//  Created by Paul Tangen on 12/28/19.
//  Copyright © 2019 Paul Tangen. All rights reserved.
//

import UIKit
import Charts

protocol WatchViewDelegate: class {
    func openCompanyDetail(company: Company)
}

class WatchView: UIView, UITableViewDataSource, UITableViewDelegate {
    
    let store = DataStore.sharedInstance
    weak var delegate: WatchViewDelegate?
    let watchTableViewInst = UITableView()
    let countLabel = UILabel()
    let companiesLabel = UILabel()
    let pageDescLabel = UILabel()
    var companiesArr = [Company]()
    let activityIndicator = UIView()
    
    override init(frame:CGRect){
        super.init(frame: frame)
        self.accessibilityLabel = "watchView"
        
        self.setHeadingLabels()
        
        self.watchTableViewInst.delegate = self
        self.watchTableViewInst.dataSource = self
        self.watchTableViewInst.register(WatchTableViewCell.self, forCellReuseIdentifier: "prototype")
        self.watchTableViewInst.separatorColor = UIColor.clear
        self.watchTableViewInst.accessibilityLabel = "watchTableViewInst"
        self.watchTableViewInst.accessibilityIdentifier = "watchTableViewInst"
        
        self.pageLayoutLabels()
        self.updateCompanyData(selectedTab: .watch) // must init chart even though there is no data yet
    }
    
    func setHeadingLabels() {
        self.companiesArr.count > 0 ? (self.pageDescLabel.text = "These are the companies with stock we have purchased.\r\rThe previous and expected returns are displayed.") : (self.pageDescLabel.text = "Mark the companies with stock that has been pu")
        self.countLabel.text = "\(self.companiesArr.count)"
        self.companiesArr.count == 1 ? (self.companiesLabel.text = "company") : (self.companiesLabel.text = "companies")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func pageLayoutLabels() {
        self.addSubview(self.countLabel)
        self.countLabel.translatesAutoresizingMaskIntoConstraints = false
        self.countLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 110).isActive = true
        self.countLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        self.countLabel.rightAnchor.constraint(equalTo: self.centerXAnchor, constant: -45).isActive = true
        self.countLabel.font = UIFont(name: Constants.appFont.regular.rawValue, size: Constants.fontSize.xxlarge.rawValue)
        self.countLabel.textAlignment = .right
    
        self.addSubview(self.companiesLabel)
        self.companiesLabel.translatesAutoresizingMaskIntoConstraints = false
        self.companiesLabel.topAnchor.constraint(equalTo: self.countLabel.bottomAnchor, constant: 0).isActive = true
        self.companiesLabel.leftAnchor.constraint(equalTo: self.countLabel.leftAnchor, constant: 0).isActive = true
        self.companiesLabel.rightAnchor.constraint(equalTo: self.countLabel.rightAnchor, constant: 0).isActive = true
        self.companiesLabel.font = UIFont(name: Constants.appFont.bold.rawValue, size: Constants.fontSize.small.rawValue)
        self.companiesLabel.textAlignment = .right
    
        self.addSubview(self.pageDescLabel)
        self.pageDescLabel.translatesAutoresizingMaskIntoConstraints = false
        self.pageDescLabel.leftAnchor.constraint(equalTo: self.centerXAnchor, constant: -30).isActive = true
        self.pageDescLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        self.pageDescLabel.bottomAnchor.constraint(equalTo: self.companiesLabel.bottomAnchor, constant: 0).isActive = true
        self.pageDescLabel.font = UIFont(name: Constants.appFont.regular.rawValue, size: Constants.fontSize.xsmall.rawValue)
        self.pageDescLabel.numberOfLines = 0
        
        // watchTableViewInst
        self.addSubview(self.watchTableViewInst)
        self.watchTableViewInst.translatesAutoresizingMaskIntoConstraints = false
        self.watchTableViewInst.topAnchor.constraint(equalTo: self.pageDescLabel.bottomAnchor, constant: 20).isActive = true
        self.watchTableViewInst.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -90).isActive = true
        self.watchTableViewInst.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        self.watchTableViewInst.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        
        updateCompanyData(selectedTab: .watch)
    }
    
    func pageLayoutNoData() {
        self.addSubview(self.activityIndicator)
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.activityIndicator.heightAnchor.constraint(equalToConstant: 80).isActive = true
        self.activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.activityIndicator.widthAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    // create array for view
    func updateCompanyData(selectedTab: Constants.EquityTabValue) {
        self.companiesArr.removeAll()
        self.companiesArr = self.store.companies.filter({$0.tab == selectedTab})
        self.countLabel.text = String(self.companiesArr.count)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return self.companiesArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 72
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = WatchTableViewCell(style: .default, reuseIdentifier: "prototype")
        cell.selectionStyle = .none
        
        // truncate the name if needed, so it fits on the left side of the bar
        var shortName: String = ""
        let maxSize = 18
        if(self.companiesArr[indexPath.row].name.count <= maxSize) {
            shortName = self.companiesArr[indexPath.row].name
        } else {
            shortName = self.truncateName(fullName: self.companiesArr[indexPath.row].name, maxSize: maxSize)
        }
        
        if let expected_roi = self.companiesArr[indexPath.row].expected_roi, let previous_roi = self.companiesArr[indexPath.row].previous_roi {
            
            cell.textLabel?.text = shortName.capitalized
            
            //cell.previousROIViewWidth = CGFloat(previous_roi)
            //cell.expectedROIViewWidth = CGFloat(expected_roi)
            
            cell.previousROIView.widthAnchor.constraint(equalToConstant: CGFloat(previous_roi*3)).isActive = true
            cell.expectedROIView.widthAnchor.constraint(equalToConstant: CGFloat(expected_roi*3)).isActive = true
            
            cell.previousROILabel.text = "\(Int(previous_roi))%"
            cell.expectedROILabel.text = "\(Int(expected_roi))%"
            
            return cell
        }
        return cell // should never get here
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.openCompanyDetail(company: self.companiesArr[indexPath.row])
    }
    
    func truncateName(fullName: String, maxSize: Int) -> String {
        // reduce the company name to the maxSize or less, but truncate on a space in the name so it looks right
        var currentSize: Int = 0
        var truncatedName: String = ""
        let subNameArr = fullName.components(separatedBy: " ")
        
        for subName in subNameArr {
            if currentSize + subName.count <= maxSize {
                currentSize = currentSize + subName.count
                if truncatedName.count == 0 {
                    truncatedName = subName
                } else {
                    truncatedName = truncatedName + " " + subName
                }
            }
        }
        return truncatedName
    }
    
    func showActivityIndicator(uiView: UIView) {
        self.activityIndicator.backgroundColor = UIColor(named: .blue)
        self.activityIndicator.layer.cornerRadius = 10
        self.activityIndicator.clipsToBounds = true
        
        let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        actInd.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        actInd.style = UIActivityIndicatorView.Style.large
        actInd.center = CGPoint(x: 40, y: 40)
        
        self.activityIndicator.addSubview(actInd)
        actInd.startAnimating()
    }
}
