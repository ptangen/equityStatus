//
//  SellView.swift
//  EquityStatus
//
//  Created by Paul Tangen on 12/19/16.
//  Copyright © 2016 Paul Tangen. All rights reserved.
//

import UIKit

class SellView: UIView, UITableViewDataSource, UITableViewDelegate  {
    
    let store = DataStore.sharedInstance
    var equitiesMetadataDict: [String:[String]] = [:]
    let sellTableViewInst = UITableView()
    let activityIndicator: UIView = UIView()
    let subTitle: UILabel = UILabel()
        
    override init(frame:CGRect){
        super.init(frame: frame)
        self.store.getEquitiesMetadataFromCoreData()
        self.sellTableViewInst.delegate = self
        self.sellTableViewInst.dataSource = self
        self.sellTableViewInst.register(SellTableViewCell.self, forCellReuseIdentifier: "prototype")
        self.sellTableViewInst.separatorColor = UIColor.clear
        self.pageLayout()
        
        
        // If we dont have the metadata for the equities, fetch it else use the metadata stored in coredata.
        if self.store.equitiesMetadata.count == 0 {
            
            self.showActivityIndicatory(uiView: self)
            self.sellTableViewInst.isHidden = true
            
            APIClient.getEquitiesMetadataFromDB() {
                self.createSellEquitiesDict(sectionHeadings: "nameFirst")
                
                OperationQueue.main.addOperation {
                    self.subTitle.text = "Equities with one or more failed measures."
                    self.activityIndicator.isHidden = true
                    self.sellTableViewInst.isHidden = false
                    self.sellTableViewInst.reloadData()
                }
            }
        } else {
            self.subTitle.text = "Equities with one or more failed measures."
            self.createSellEquitiesDict(sectionHeadings: "nameFirst")
        }
    }
    
    func showActivityIndicatory(uiView: UIView) {
        self.subTitle.text = "Loading over 4,000 equities (just once) ..."
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
        return self.equitiesMetadataDict.keys.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Array(self.equitiesMetadataDict.keys).sorted()[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor(named: UIColor.ColorName(rawValue: UIColor.ColorName.gold.rawValue)!)
        header.textLabel?.textColor = UIColor(named: UIColor.ColorName.white)
        header.textLabel?.font = UIFont(name: Constants.appFont.bold.rawValue, size: Constants.fontSize.small.rawValue)
        header.alpha = 0.8
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let keys = Array(self.equitiesMetadataDict.keys).sorted()
        return self.equitiesMetadataDict[keys[section]]!.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 42
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SellTableViewCell(style: .default, reuseIdentifier: "prototype")
        let keys = Array(self.equitiesMetadataDict.keys).sorted()
        let currentKey = keys[indexPath.section]
        let currentSectionValues = self.equitiesMetadataDict[currentKey]
        let itemTitle = currentSectionValues?[indexPath.row]
        cell.textLabel?.text = itemTitle
        return cell
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return Array(self.equitiesMetadataDict.keys).sorted()
    }
    
    // end tableview config
    
    
    func pageLayout() {
        // subtitle
        self.addSubview(self.subTitle)
        self.subTitle.translatesAutoresizingMaskIntoConstraints = false
        self.subTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 80).isActive = true
        self.subTitle.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        self.subTitle.font = UIFont(name: Constants.appFont.regular.rawValue, size: Constants.fontSize.small.rawValue)
        
        self.addSubview(self.sellTableViewInst)
        self.sellTableViewInst.translatesAutoresizingMaskIntoConstraints = false
        self.sellTableViewInst.topAnchor.constraint(equalTo: self.subTitle.bottomAnchor, constant: 6).isActive = true
        self.sellTableViewInst.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -50).isActive = true
        self.sellTableViewInst.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        self.sellTableViewInst.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        
        self.addSubview(self.activityIndicator)
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.activityIndicator.heightAnchor.constraint(equalToConstant: 80).isActive = true
        self.activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.activityIndicator.widthAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    func createSellEquitiesDict(sectionHeadings: String) {
        // create a dictionary of the equity metadata by either first char of the ticker or name
        for equityMetadata in self.store.equitiesMetadata {
            if sectionHeadings == "tickerFirst" {
                if let tickerFirst = equityMetadata.tickerFirst {
                    self.equitiesMetadataDict[tickerFirst] = []
                }
            } else {
                if let nameFirst = equityMetadata.nameFirst {
                    self.equitiesMetadataDict[nameFirst] = []
                }
            }
        }
        
        // add the dictionary values to the keys
        for key in self.equitiesMetadataDict.keys {
            var valuesForCurrentKey: [String] = []
            for equityMetadata in self.store.equitiesMetadata {
                if sectionHeadings == "tickerFirst" {
                    if equityMetadata.tickerFirst == key {
                        valuesForCurrentKey.append("\(equityMetadata.ticker!) (\(equityMetadata.name!))")
                    }
                } else {
                    if equityMetadata.nameFirst == key {
                        valuesForCurrentKey.append("\(equityMetadata.name!) (\(equityMetadata.ticker!))")
                    }
                }
            }
            self.equitiesMetadataDict[key] = valuesForCurrentKey // append the array to the dictionary key
        }
        //dump(equitiesMetadataDict)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
