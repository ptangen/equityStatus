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
}

class SellView: UIView, UITableViewDataSource, UITableViewDelegate  {
    
    weak var delegate: SellViewDelegate?
    let store = DataStore.sharedInstance
    var filteredEquitiesMetadata = [EquityMetadata]()
    let sellTableViewInst = UITableView()
    let activityIndicator: UIView = UIView()
    let subTitle: UILabel = UILabel()
    
    let searchController = UISearchController(searchResultsController: nil)
        
    override init(frame:CGRect){
        super.init(frame: frame)
        self.store.getEquitiesMetadataFromCoreData()
        self.sellTableViewInst.delegate = self
        self.sellTableViewInst.dataSource = self
        self.sellTableViewInst.register(SellTableViewCell.self, forCellReuseIdentifier: "prototype")
        self.sellTableViewInst.separatorColor = UIColor.clear
        self.pageLayout()
        
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false
        
        self.sellTableViewInst.tableHeaderView = self.searchController.searchBar
        
        // If we dont have the metadata for the equities, fetch it else use the metadata stored in coredata.
        if self.store.equitiesMetadata.count == 0 {
            
            self.showActivityIndicator(uiView: self)
            self.sellTableViewInst.isHidden = true

            APIClient.getEquitiesMetadataFromDB() {
                OperationQueue.main.addOperation {
                    self.activityIndicator.isHidden = true
                    self.sellTableViewInst.isHidden = false
                    self.sellTableViewInst.reloadData()
                }
            }
        }
    }
    
    func showActivityIndicator(uiView: UIView) {
        self.activityIndicator.backgroundColor = UIColor(named: UIColor.ColorName.blue)
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
        return self.store.equitiesMetadata.count
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
        cell.textLabel?.text = equityMetadata.name! +  " (" + equityMetadata.ticker! + ")"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if searchController.isActive && searchController.searchBar.text != "" {
            self.delegate?.openDetail(self.filteredEquitiesMetadata[indexPath.row].ticker!)
        } else {
            self.delegate?.openDetail(self.store.equitiesMetadata[indexPath.row].ticker!)
        }
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        self.filteredEquitiesMetadata = self.store.equitiesMetadata.filter { equityMetadata in
            let nameAndTicker = equityMetadata.name! + equityMetadata.ticker!
            return nameAndTicker.lowercased().contains(searchText.lowercased())
        }
        self.sellTableViewInst.reloadData()
    }
    
    func pageLayout() {
        
        self.addSubview(self.sellTableViewInst)
        self.sellTableViewInst.translatesAutoresizingMaskIntoConstraints = false
        self.sellTableViewInst.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        self.sellTableViewInst.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -50).isActive = true
        self.sellTableViewInst.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        self.sellTableViewInst.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        
        self.addSubview(self.activityIndicator)
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.activityIndicator.heightAnchor.constraint(equalToConstant: 80).isActive = true
        self.activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.activityIndicator.widthAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SellView: UISearchResultsUpdating {
    public func updateSearchResults(for searchController: UISearchController) {
        self.filterContentForSearchText(searchText: self.searchController.searchBar.text!)
    }
}
