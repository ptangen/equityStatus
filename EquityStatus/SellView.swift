//
//  SellView.swift
//  EquityStatus
//
//  Created by Paul Tangen on 12/19/16.
//  Copyright © 2016 Paul Tangen. All rights reserved.
//

import UIKit

protocol SellViewDelegate: class {
    func openDetail(_: String)
    func showAlertMessage(_: String)
}

class SellView: UIView, UITableViewDataSource, UITableViewDelegate {
    
    weak var delegate: SellViewDelegate?
    let store = DataStore.sharedInstance
    var filteredEquitiesMetadata = [EquityMetadata]()
    let sellTableViewInst = UITableView()
    let activityIndicator = UIView()
    let countLabel = UILabel()
    let companiesLabel = UILabel()
    let pageDescLabel = UILabel()
    var sellTableViewInstYConstraintWithHeading = NSLayoutConstraint()
    var sellTableViewInstYConstraintWithoutHeading = NSLayoutConstraint()
    var sellViewItemCount = Int()
    
    let searchController = UISearchController(searchResultsController: nil)
        
    override init(frame:CGRect){
        super.init(frame: frame)
        self.accessibilityLabel = "sellViewInst"
        self.store.getEquitiesMetadataFromCoreData()
        self.sellTableViewInst.delegate = self
        self.sellTableViewInst.dataSource = self
        self.sellTableViewInst.register(SellTableViewCell.self, forCellReuseIdentifier: "prototype")
        self.sellTableViewInst.separatorColor = UIColor.clear
        self.sellTableViewInst.accessibilityIdentifier = "sellTableViewInst"
        self.pageLayout()
        
        self.searchController.searchResultsUpdater = self
        // deprecated in 4.2: self.searchController.dimsBackgroundDuringPresentation = false
        self.sellTableViewInst.tableHeaderView = self.searchController.searchBar
        self.searchController.searchBar.accessibilityLabel = "searchBar"
        
    }
    
    func getEquityMetadata () {
        // If we dont have the metadata for the equities, fetch it else use the metadata stored in coredata.
        if self.store.equitiesMetadata.count == 0 {
            
            self.showActivityIndicator(uiView: self)
            self.sellTableViewInst.isHidden = true
            self.pageDescLabel.text = "Searching for companies that have failed an evaluation."
            
            APIClient.getEquitiesMetadataFromDB() {isSuccessful in
                if isSuccessful {
                    OperationQueue.main.addOperation {
                        self.activityIndicator.isHidden = true
                        self.sellTableViewInst.isHidden = false
                        self.sellViewItemCount = Utilities.getSellTabCount()
                        self.countLabel.text = String(self.sellViewItemCount)
                        self.sellTableViewInst.reloadData()
                        self.pageDescLabel.text = "These companies have failed one or more evalutions. As a result, these company's stock is rated a sell per this methodology."
                    }
                } else {
                    OperationQueue.main.addOperation {
                        self.activityIndicator.isHidden = true
                    }
                    self.delegate?.showAlertMessage("Unable to retrieve data from the server.")
                }
            }
        } else {
            // set header label
            self.pageDescLabel.text = "These companies have failed one or more evalutions. As a result, the stock from these companies is considered a sell per this methodology."
        }
    }
    
    func showActivityIndicator(uiView: UIView) {
        self.activityIndicator.backgroundColor = UIColor(named: .blue)
        self.activityIndicator.layer.cornerRadius = 10
        self.activityIndicator.clipsToBounds = true
        
        let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        actInd.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        actInd.center = CGPoint(x: 40, y: 40)

        self.activityIndicator.addSubview(actInd)
        actInd.startAnimating()
    }
    
    // tableview config
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredEquitiesMetadata.count
        }
        return self.sellViewItemCount
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 42
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SellTableViewCell(style: .default, reuseIdentifier: "prototype")
        let equityMetadata: EquityMetadata
        if searchController.isActive && searchController.searchBar.text != "" {
            equityMetadata = self.filteredEquitiesMetadata[indexPath.row]
        } else {
            equityMetadata = self.store.equitiesMetadata[indexPath.row]
        }
        if equityMetadata.showInSellTab {
            if let name = equityMetadata.name?.capitalized, let ticker = equityMetadata.ticker {
                cell.textLabel?.text = name +  " (" + ticker + ")"
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchController.isActive && searchController.searchBar.text != "" {
            if let ticker = self.filteredEquitiesMetadata[indexPath.row].ticker {
                self.delegate?.openDetail(ticker)
            }
        } else {
            if let ticker = self.store.equitiesMetadata[indexPath.row].ticker {
                self.delegate?.openDetail(ticker)
            }
        }
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {

        // hide/show labels about company count above the tableview when search is being used
        if self.sellTableViewInstYConstraintWithHeading.isActive {
            self.sellTableViewInstYConstraintWithHeading.isActive = false
            self.sellTableViewInstYConstraintWithoutHeading.isActive = true
            self.pageDescLabel.isHidden = true
        } else {
            self.sellTableViewInstYConstraintWithHeading.isActive = true
            self.sellTableViewInstYConstraintWithoutHeading.isActive = false
            self.pageDescLabel.isHidden = false
        }
        
        self.filteredEquitiesMetadata = self.store.equitiesMetadata.filter { equityMetadata in
            var nameAndTicker = String()
            if let name = equityMetadata.name, let ticker = equityMetadata.ticker {
                nameAndTicker = name + ticker
            }
            return nameAndTicker.lowercased().contains(searchText.lowercased())
        }
        self.sellTableViewInst.reloadData()
    }
    
    func pageLayout() {
        
        //countLabel
        self.addSubview(self.countLabel)
        self.countLabel.translatesAutoresizingMaskIntoConstraints = false
        self.countLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 110).isActive = true
        self.countLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        self.countLabel.rightAnchor.constraint(equalTo: self.centerXAnchor, constant: -45).isActive = true
        self.countLabel.font = UIFont(name: Constants.appFont.regular.rawValue, size: Constants.fontSize.xxlarge.rawValue)
        self.countLabel.textAlignment = .right
        
        // companiesLabel
        self.addSubview(self.companiesLabel)
        self.companiesLabel.translatesAutoresizingMaskIntoConstraints = false
        self.companiesLabel.topAnchor.constraint(equalTo: self.countLabel.bottomAnchor, constant: 0).isActive = true
        self.companiesLabel.leftAnchor.constraint(equalTo: self.countLabel.leftAnchor, constant: 0).isActive = true
        self.companiesLabel.rightAnchor.constraint(equalTo: self.countLabel.rightAnchor, constant: 0).isActive = true
        self.companiesLabel.font = UIFont(name: Constants.appFont.bold.rawValue, size: Constants.fontSize.small.rawValue)
        self.self.store.equitiesMetadata.count == 1 ? (self.companiesLabel.text = "company") : (self.companiesLabel.text = "companies")
        self.companiesLabel.textAlignment = .right
        
        // pageDescLabel
        self.addSubview(self.pageDescLabel)
        self.pageDescLabel.translatesAutoresizingMaskIntoConstraints = false
        self.pageDescLabel.leftAnchor.constraint(equalTo: self.centerXAnchor, constant: -30).isActive = true
        self.pageDescLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        self.pageDescLabel.bottomAnchor.constraint(equalTo: self.companiesLabel.bottomAnchor, constant: 0).isActive = true
        self.pageDescLabel.font = UIFont(name: Constants.appFont.regular.rawValue, size: Constants.fontSize.xsmall.rawValue)
        self.pageDescLabel.numberOfLines = 0
        
        // sellTableViewInst
        self.addSubview(self.sellTableViewInst)
        self.sellTableViewInst.translatesAutoresizingMaskIntoConstraints = false
        self.sellTableViewInstYConstraintWithHeading = self.sellTableViewInst.topAnchor.constraint(equalTo: self.pageDescLabel.bottomAnchor, constant: 24)
        self.sellTableViewInstYConstraintWithHeading.isActive = true
        self.sellTableViewInstYConstraintWithoutHeading = self.sellTableViewInst.topAnchor.constraint(equalTo: self.topAnchor, constant: 64)
        self.sellTableViewInstYConstraintWithoutHeading.isActive = false
        self.sellTableViewInst.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -50).isActive = true
        self.sellTableViewInst.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        self.sellTableViewInst.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        
        // activityIndicator
        self.addSubview(self.activityIndicator)
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.activityIndicator.heightAnchor.constraint(equalToConstant: 80).isActive = true
        self.activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.activityIndicator.widthAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension SellView: UISearchResultsUpdating {
    public func updateSearchResults(for searchController: UISearchController) {
        if let searchText = self.searchController.searchBar.text {
            self.filterContentForSearchText(searchText: searchText)
        }
    }
}
