//
//  EvaluationView.swift
//  EquityStatus
//
//  Created by Paul Tangen on 12/19/16.
//  Copyright © 2016 Paul Tangen. All rights reserved.
//

import UIKit

protocol EvaluationViewDelegate: class {
    func openEquityDetail(_: Equity)
    func showAlertMessage(_: String)
}

class EvaluationView: UIView, UITableViewDataSource, UITableViewDelegate {

    let store = DataStore.sharedInstance
    weak var delegate: EvaluationViewDelegate?
    let evaluationTableViewInst = UITableView()
    let countLabel = UILabel()
    let companiesLabel = UILabel()
    let pageDescLabel = UILabel()
    let activityIndicator = UIView()
    var equitiesForEvaluation = [Equity]()
    
    override init(frame:CGRect){
        super.init(frame: frame)
        self.evaluationTableViewInst.delegate = self
        self.evaluationTableViewInst.dataSource = self
        self.evaluationTableViewInst.register(EvaluationTableViewCell.self, forCellReuseIdentifier: "prototype")
        self.evaluationTableViewInst.separatorColor = UIColor.clear
        createEquitiesForEvaluation()
        self.pageLayout()
        
        // get the data
        if equitiesForEvaluation.count == 0 {
            self.pageDescLabel.text = "Searching for equities to evaluate..."
            self.countLabel.text = "?"
            self.showActivityIndicator(uiView: self)
            self.evaluationTableViewInst.isHidden = true
            
            APIClient.getEquitiesFromDB(mode: "pass,passOrNoData"){isSuccessful in
                if isSuccessful {
                    OperationQueue.main.addOperation {
                        self.activityIndicator.isHidden = true
                        self.evaluationTableViewInst.isHidden = false
                        self.createEquitiesForEvaluation()
                        self.evaluationTableViewInst.reloadData()
                    }
                } else {
                    OperationQueue.main.addOperation {
                        self.activityIndicator.isHidden = true
                    }
                    self.delegate?.showAlertMessage("Unable to retrieve data from the server.")
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // create array for analysis view
    func createEquitiesForEvaluation() {
        self.equitiesForEvaluation.removeAll()
        for equity in self.store.equities {
            if equity.tab == .evaluate {
                self.equitiesForEvaluation.append(equity)
            }
        }
        // set the labels in the heading
        self.equitiesForEvaluation.count == 1 ? (self.pageDescLabel.text = "This company has passed several assessments and failed none. Evaluate the remaining measures to determine if the company's stock is a buy or sell.") : (self.pageDescLabel.text = "These companies have passed several assessments and failed none. Evaluate the remaining measures to determine if the companies' stock is a buy or a sell.")
        self.countLabel.text = "\(self.equitiesForEvaluation.count)"
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
        self.equitiesForEvaluation.count == 1 ? (self.companiesLabel.text = "company") : (self.companiesLabel.text = "companies")
        self.companiesLabel.textAlignment = .right
        
        // pageDescLabel
        self.addSubview(self.pageDescLabel)
        self.pageDescLabel.translatesAutoresizingMaskIntoConstraints = false
        self.pageDescLabel.leftAnchor.constraint(equalTo: self.centerXAnchor, constant: -30).isActive = true
        self.pageDescLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        self.pageDescLabel.bottomAnchor.constraint(equalTo: self.companiesLabel.bottomAnchor, constant: 0).isActive = true
        self.pageDescLabel.font = UIFont(name: Constants.appFont.regular.rawValue, size: Constants.fontSize.xsmall.rawValue)
        self.pageDescLabel.numberOfLines = 0
        
        // evaluationTableViewInst
        self.addSubview(self.evaluationTableViewInst)
        self.evaluationTableViewInst.translatesAutoresizingMaskIntoConstraints = false
        self.evaluationTableViewInst.topAnchor.constraint(equalTo: self.pageDescLabel.bottomAnchor, constant: 10).isActive = true
        self.evaluationTableViewInst.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -50).isActive = true
        self.evaluationTableViewInst.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        self.evaluationTableViewInst.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        
        // activityIndicator
        self.addSubview(self.activityIndicator)
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.activityIndicator.heightAnchor.constraint(equalToConstant: 80).isActive = true
        self.activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.activityIndicator.widthAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.equitiesForEvaluation.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 72
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = EvaluationTableViewCell(style: .default, reuseIdentifier: "prototype")
        cell.selectionStyle = .none
        let textLabel = self.equitiesForEvaluation[indexPath.row].name
        cell.textLabel?.text = textLabel.capitalized
        
        // set the status icons and color for each of the equity's measures
        Utilities.setStatusIcon(status: self.equitiesForEvaluation[indexPath.row].ROEaStatus, uiLabel: cell.statusIcons[0])
        Utilities.setStatusIcon(status: self.equitiesForEvaluation[indexPath.row].EPSiStatus, uiLabel: cell.statusIcons[1])
        Utilities.setStatusIcon(status: self.equitiesForEvaluation[indexPath.row].EPSvStatus, uiLabel: cell.statusIcons[2])
        Utilities.setStatusIcon(status: self.equitiesForEvaluation[indexPath.row].BViStatus, uiLabel: cell.statusIcons[3])
        Utilities.setStatusIcon(status: self.equitiesForEvaluation[indexPath.row].DRaStatus, uiLabel: cell.statusIcons[4])
        Utilities.setStatusIcon(status: self.equitiesForEvaluation[indexPath.row].SOrStatus, uiLabel: cell.statusIcons[5])
        Utilities.setStatusIcon(status: self.equitiesForEvaluation[indexPath.row].previousROIStatus, uiLabel: cell.statusIcons[6])
        Utilities.setStatusIcon(status: self.equitiesForEvaluation[indexPath.row].expectedROIStatus, uiLabel: cell.statusIcons[7])
        Utilities.setStatusIcon(status: self.equitiesForEvaluation[indexPath.row].q1Status, uiLabel: cell.statusIcons[8])
        Utilities.setStatusIcon(status: self.equitiesForEvaluation[indexPath.row].q2Status, uiLabel: cell.statusIcons[9])
        Utilities.setStatusIcon(status: self.equitiesForEvaluation[indexPath.row].q3Status, uiLabel: cell.statusIcons[10])
        Utilities.setStatusIcon(status: self.equitiesForEvaluation[indexPath.row].q4Status, uiLabel: cell.statusIcons[11])
        Utilities.setStatusIcon(status: self.equitiesForEvaluation[indexPath.row].q5Status, uiLabel: cell.statusIcons[12])
        Utilities.setStatusIcon(status: self.equitiesForEvaluation[indexPath.row].q6Status, uiLabel: cell.statusIcons[13])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.openEquityDetail(self.equitiesForEvaluation[indexPath.row])
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
}
