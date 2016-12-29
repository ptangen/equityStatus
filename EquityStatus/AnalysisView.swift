//
//  AnalysisView.swift
//  EquityStatus
//
//  Created by Paul Tangen on 12/19/16.
//  Copyright © 2016 Paul Tangen. All rights reserved.
//

import UIKit

protocol AnalysisViewDelegate: class {
    func openDetail(_: Equity)
}

class AnalysisView: UIView, UITableViewDataSource, UITableViewDelegate {

    weak var delegate: AnalysisViewDelegate?
    let analysisTableViewInst = UITableView()
    let subTitle: UILabel = UILabel()
    let store = DataStore.sharedInstance
    let activityIndicator: UIView = UIView()
    
    override init(frame:CGRect){
        super.init(frame: frame)
        self.analysisTableViewInst.delegate = self
        self.analysisTableViewInst.dataSource = self
        self.analysisTableViewInst.register(AnalysisTableViewCell.self, forCellReuseIdentifier: "prototype")
        self.analysisTableViewInst.separatorColor = UIColor.clear
        self.pageLayout()
        
        if store.equities.count == 0 {
            self.subTitle.text = "Loading equities for evaluation..."
            APIClient.getEquitiesFromDB(){
                OperationQueue.main.addOperation {
                    self.subTitle.text = "Evaluate the qualitative measures."
                    self.activityIndicator.isHidden = true
                    self.analysisTableViewInst.isHidden = false
                    self.analysisTableViewInst.reloadData()
                }
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
        self.subTitle.text = "Evaluate the qualitative measures."
        self.subTitle.font = UIFont(name: Constants.appFont.regular.rawValue, size: Constants.fontSize.small.rawValue)
        
        self.addSubview(self.analysisTableViewInst)
        self.analysisTableViewInst.translatesAutoresizingMaskIntoConstraints = false
        self.analysisTableViewInst.topAnchor.constraint(equalTo: self.subTitle.bottomAnchor, constant: 0).isActive = true
        self.analysisTableViewInst.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 180).isActive = true
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
        
        // set the status icons and color for each of the equity's measures
        Utilities.setStatusIcon(status: self.store.equities[indexPath.row].ROEaStatus, label: cell.statusIcons[0])
        Utilities.setStatusIcon(status: self.store.equities[indexPath.row].EPSiStatus, label: cell.statusIcons[1])
        Utilities.setStatusIcon(status: self.store.equities[indexPath.row].EPSvStatus, label: cell.statusIcons[2])
        Utilities.setStatusIcon(status: self.store.equities[indexPath.row].BViStatus, label: cell.statusIcons[3])
        Utilities.setStatusIcon(status: self.store.equities[indexPath.row].DRaStatus, label: cell.statusIcons[4])
        Utilities.setStatusIcon(status: self.store.equities[indexPath.row].SOrStatus, label: cell.statusIcons[5])
        Utilities.setStatusIcon(status: self.store.equities[indexPath.row].previousROIStatus, label: cell.statusIcons[6])
        Utilities.setStatusIcon(status: self.store.equities[indexPath.row].expectedROIStatus, label: cell.statusIcons[7])
        Utilities.setStatusIcon(status: self.store.equities[indexPath.row].q1Status, label: cell.statusIcons[8])
        Utilities.setStatusIcon(status: self.store.equities[indexPath.row].q2Status, label: cell.statusIcons[9])
        Utilities.setStatusIcon(status: self.store.equities[indexPath.row].q3Status, label: cell.statusIcons[10])
        Utilities.setStatusIcon(status: self.store.equities[indexPath.row].q4Status, label: cell.statusIcons[11])
        Utilities.setStatusIcon(status: self.store.equities[indexPath.row].q5Status, label: cell.statusIcons[12])
        Utilities.setStatusIcon(status: self.store.equities[indexPath.row].q6Status, label: cell.statusIcons[13])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.openDetail(store.equities[indexPath.row])
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
