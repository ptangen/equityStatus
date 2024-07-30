//
//  EvaluationView.swift
//  EquityStatus
//
//  Created by Paul Tangen on 12/19/16.
//  Copyright © 2016 Paul Tangen. All rights reserved.
//

import UIKit

protocol EvaluationViewDelegate: class {
    func openCompanyDetail(company: Company)
}

class EvaluationView: UIView, UITableViewDataSource, UITableViewDelegate {

    let store = DataStore.sharedInstance
    weak var delegate: EvaluationViewDelegate?
    let evaluationTableViewInst = UITableView()
    let countLabel = UILabel()
    let companiesLabel = UILabel()
    let pageDescLabel = UILabel()
    let activityIndicator = UIView()
    var companiesToEvaluate = [Company]()
    
    override init(frame:CGRect){
        super.init(frame: frame)
        self.accessibilityLabel = "evaluationViewInst"
        self.evaluationTableViewInst.delegate = self
        self.evaluationTableViewInst.dataSource = self
        self.evaluationTableViewInst.register(EvaluationTableViewCell.self, forCellReuseIdentifier: "prototype")
        self.evaluationTableViewInst.separatorColor = UIColor.clear
        self.evaluationTableViewInst.accessibilityLabel = "evaluationTableViewInst"
        self.evaluationTableViewInst.accessibilityIdentifier = "evaluationTableViewInst"

        companiesToEvaluate = self.store.companies.filter({$0.tab == .evaluate})
        self.evaluationTableViewInst.reloadData()
        self.setHeadingLabels()
        self.evaluationTableViewInst.isHidden = false
        self.activityIndicator.isHidden = true
        
        self.pageLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func updateCompaniesToEvaluate(){
        self.companiesToEvaluate = self.store.companies.filter({$0.tab == .evaluate})
        self.evaluationTableViewInst.reloadData()
        self.countLabel.text = String(self.companiesToEvaluate.count)
    }
    
    func setHeadingLabels() {
        // set the labels in the heading
        self.companiesToEvaluate.count == 1 ? (self.pageDescLabel.text = "This company has passed several assessments and failed none. Tap to evaluate the remaining measures and determine if the company's stock is a buy or sell.") : (self.pageDescLabel.text = "These companies have passed several assessments and failed none. Evaluate the remaining subjective measures.")
        self.countLabel.text = "\(self.companiesToEvaluate.count)"
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
        self.companiesToEvaluate.count == 1 ? (self.companiesLabel.text = "company") : (self.companiesLabel.text = "companies")
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
        self.evaluationTableViewInst.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -90).isActive = true
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
        return self.companiesToEvaluate.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 72
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = EvaluationTableViewCell(style: .default, reuseIdentifier: "prototype")
        cell.selectionStyle = .none
        let textLabel = self.companiesToEvaluate[indexPath.row].name
        cell.textLabel?.text = textLabel.capitalized
        
        // set the status icons and color for each of the equity's measures
        Utilities.getStatusIcon(status: self.companiesToEvaluate[indexPath.row].roe_avg_passed, uiLabel: cell.statusIcons[0])
        Utilities.getStatusIcon(status: self.companiesToEvaluate[indexPath.row].eps_i_passed, uiLabel: cell.statusIcons[1])
        Utilities.getStatusIcon(status: self.companiesToEvaluate[indexPath.row].eps_sd_passed, uiLabel: cell.statusIcons[2])
        Utilities.getStatusIcon(status: self.companiesToEvaluate[indexPath.row].bv_i_passed, uiLabel: cell.statusIcons[3])
        Utilities.getStatusIcon(status: self.companiesToEvaluate[indexPath.row].dr_avg_passed, uiLabel: cell.statusIcons[4])
        Utilities.getStatusIcon(status: self.companiesToEvaluate[indexPath.row].so_reduced_passed, uiLabel: cell.statusIcons[5])
        Utilities.getStatusIcon(status: self.companiesToEvaluate[indexPath.row].previous_roi_passed, uiLabel: cell.statusIcons[6])
        Utilities.getStatusIcon(status: self.companiesToEvaluate[indexPath.row].expected_roi_passed, uiLabel: cell.statusIcons[7])
        Utilities.getStatusIcon(status: self.companiesToEvaluate[indexPath.row].q1_passed, uiLabel: cell.statusIcons[8])
        Utilities.getStatusIcon(status: self.companiesToEvaluate[indexPath.row].q2_passed, uiLabel: cell.statusIcons[9])
        Utilities.getStatusIcon(status: self.companiesToEvaluate[indexPath.row].q3_passed, uiLabel: cell.statusIcons[10])
        Utilities.getStatusIcon(status: self.companiesToEvaluate[indexPath.row].q4_passed, uiLabel: cell.statusIcons[11])
        Utilities.getStatusIcon(status: self.companiesToEvaluate[indexPath.row].q5_passed, uiLabel: cell.statusIcons[12])
        Utilities.getStatusIcon(status: self.companiesToEvaluate[indexPath.row].q6_passed, uiLabel: cell.statusIcons[13])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.openCompanyDetail(company: self.companiesToEvaluate[indexPath.row])
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
