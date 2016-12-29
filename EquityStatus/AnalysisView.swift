//
//  AnalysisView.swift
//  EquityStatus
//
//  Created by Paul Tangen on 12/19/16.
//  Copyright © 2016 Paul Tangen. All rights reserved.
//

import UIKit

class AnalysisView: UIView, UITableViewDataSource, UITableViewDelegate {

    let analysisTableViewInst = UITableView()
    let subTitle: UILabel = UILabel()
    //let myArray = ["Graco Inc. (GGG)", "Apple Inc. (AAPL)", "Alcoa Corporation (AA)", "Hasbro, Inc. (HAS)"]
    let store = DataStore.sharedInstance
    let activityIndicator: UIView = UIView()
    
    override init(frame:CGRect){
        super.init(frame: frame)
        self.analysisTableViewInst.delegate = self
        self.analysisTableViewInst.dataSource = self
        self.analysisTableViewInst.register(AnalysisTableViewCell.self, forCellReuseIdentifier: "prototype")
        self.analysisTableViewInst.separatorColor = UIColor.clear
        self.pageLayout()
        
        APIClient.getEquitiesFromDB(){
            OperationQueue.main.addOperation {
                self.subTitle.text = "Evaluate the qualitative measures."
                self.activityIndicator.isHidden = true
                self.analysisTableViewInst.isHidden = false
                self.analysisTableViewInst.reloadData()
            }
        }
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
        self.subTitle.text = "Loading equities for evaluation..."
        self.subTitle.font = UIFont(name: Constants.appFont.regular.rawValue, size: Constants.fontSize.small.rawValue)
        
        self.addSubview(self.analysisTableViewInst)
        self.analysisTableViewInst.translatesAutoresizingMaskIntoConstraints = false
        self.analysisTableViewInst.topAnchor.constraint(equalTo: self.subTitle.bottomAnchor, constant: 0).isActive = true
        self.analysisTableViewInst.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 80).isActive = true
        self.analysisTableViewInst.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        self.analysisTableViewInst.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.store.equities.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 72
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = AnalysisTableViewCell(style: .default, reuseIdentifier: "prototype")
        cell.selectionStyle = .none
        cell.textLabel?.text = self.store.equities[indexPath.row].name
        //cell.textLabel?.font = UIFont(name: Constants.appFont.regular.rawValue, size: Constants.fontSize.medium.rawValue)
        return cell
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
}
