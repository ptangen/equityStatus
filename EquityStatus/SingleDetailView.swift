//
//  SingleDetailView.swift
//  EquityStatus
//
//  Created by Paul Tangen on 12/30/16.
//  Copyright © 2016 Paul Tangen. All rights reserved.
//

import UIKit

class SingleDetailView: UIView {
    
    let store = DataStore.sharedInstance
    var source: String = String()
    var equity: Equity!
    var measureLongNameLabel: UILabel = UILabel()
    var statusLabel: UILabel = UILabel()
    var statusIcon: UILabel = UILabel()
    var statusValueDesc: UILabel = UILabel()
    var resultsLabel: UILabel = UILabel()
    var targetLabel: UILabel = UILabel()
    var measureCalcDescLabel: UILabel = UILabel()

    override init(frame:CGRect){
        super.init(frame: frame)
        self.pageLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func pageLayout() {
        // measureLongNameLabel
        self.addSubview(self.measureLongNameLabel)
        self.measureLongNameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.measureLongNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 80).isActive = true
        self.measureLongNameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        self.measureLongNameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        self.measureLongNameLabel.font = UIFont(name: Constants.appFont.regular.rawValue, size: Constants.fontSize.small.rawValue)
        
        // statusLabel
        self.addSubview(self.statusLabel)
        self.statusLabel.translatesAutoresizingMaskIntoConstraints = false
        self.statusLabel.topAnchor.constraint(equalTo: self.measureLongNameLabel.bottomAnchor, constant: 10).isActive = true
        self.statusLabel.leftAnchor.constraint(equalTo: self.measureLongNameLabel.leftAnchor).isActive = true
        self.statusLabel.font = UIFont(name: Constants.appFont.regular.rawValue, size: Constants.fontSize.small.rawValue)
        
        // statusIcon
        self.addSubview(self.statusIcon)
        self.statusIcon.translatesAutoresizingMaskIntoConstraints = false
        self.statusIcon.topAnchor.constraint(equalTo: self.statusLabel.topAnchor, constant: 0).isActive = true
        self.statusIcon.leftAnchor.constraint(equalTo: self.statusLabel.rightAnchor, constant: 8).isActive = true
        self.statusIcon.font = UIFont(name: Constants.iconFont.fontAwesome.rawValue, size: Constants.fontSize.small.rawValue)
        
        // statusValueDesc
        self.addSubview(self.statusValueDesc)
        self.statusValueDesc.translatesAutoresizingMaskIntoConstraints = false
        self.statusValueDesc.topAnchor.constraint(equalTo: self.statusIcon.topAnchor, constant: 0).isActive = true
        self.statusValueDesc.leftAnchor.constraint(equalTo: self.statusIcon.rightAnchor, constant: 8).isActive = true
        //self.statusValueDesc.rightAnchor.constraint(equalTo: self.measureLongNameLabel.rightAnchor).isActive = true
        self.statusValueDesc.font = UIFont(name: Constants.appFont.regular.rawValue, size: Constants.fontSize.small.rawValue)
        
        // resultsLabel
        self.addSubview(self.resultsLabel)
        self.resultsLabel.translatesAutoresizingMaskIntoConstraints = false
        self.resultsLabel.topAnchor.constraint(equalTo: self.statusLabel.bottomAnchor, constant: 10).isActive = true
        self.resultsLabel.leftAnchor.constraint(equalTo: self.statusLabel.leftAnchor).isActive = true
        self.resultsLabel.rightAnchor.constraint(equalTo: self.measureLongNameLabel.rightAnchor).isActive = true
        self.resultsLabel.font = UIFont(name: Constants.appFont.regular.rawValue, size: Constants.fontSize.small.rawValue)
        
        // targetLabel
        self.addSubview(self.targetLabel)
        self.targetLabel.translatesAutoresizingMaskIntoConstraints = false
        self.targetLabel.topAnchor.constraint(equalTo: self.resultsLabel.bottomAnchor, constant: 10).isActive = true
        self.targetLabel.leftAnchor.constraint(equalTo: self.resultsLabel.leftAnchor).isActive = true
        self.targetLabel.rightAnchor.constraint(equalTo: self.resultsLabel.rightAnchor).isActive = true
        self.targetLabel.font = UIFont(name: Constants.appFont.regular.rawValue, size: Constants.fontSize.small.rawValue)
        
        // measureCalcDescLabel
        self.addSubview(self.measureCalcDescLabel)
        self.measureCalcDescLabel.translatesAutoresizingMaskIntoConstraints = false
        self.measureCalcDescLabel.topAnchor.constraint(equalTo: self.targetLabel.bottomAnchor, constant: 10).isActive = true
        self.measureCalcDescLabel.leftAnchor.constraint(equalTo: self.targetLabel.leftAnchor).isActive = true
        self.measureCalcDescLabel.rightAnchor.constraint(equalTo: self.targetLabel.rightAnchor).isActive = true
        self.measureCalcDescLabel.font = UIFont(name: Constants.appFont.regular.rawValue, size: Constants.fontSize.small.rawValue)
        self.measureCalcDescLabel.numberOfLines = 0
    }
    
    func setResultsLabelsForMeasure(fullString: String) {
        
        self.statusLabel.text = "Status:"
        
        // extract the measure name
        let chars = fullString.characters;
        let indexLeftParen = chars.index(of: "(")!
        let indexBeforeLeftParen = chars.index(before: indexLeftParen)
        let measureShortName = fullString[chars.startIndex...indexBeforeLeftParen]
        
        // get the measure results and set the label text
        if measureShortName == "ROEa" {
            self.measureLongNameLabel.text = "Measure: " + Constants.measureLongName.ROEa.rawValue
            Utilities.setStatusIcon(status: self.equity.ROEaStatus, uiLabel: self.statusIcon)
            self.statusValueDesc.text = "(" + self.equity.ROEaStatus + ")"
            self.resultsLabel.text = "Result: " + String(self.equity.ROEaResult) + "%"
            self.targetLabel.text = "Target: " + Constants.measureTargetDesc.ROEa.rawValue
            self.measureCalcDescLabel.text = "Description: "  + Constants.measureCalcDesc.ROEa.rawValue
            
        } else if measureShortName == "EPSi" {
            self.measureLongNameLabel.text = "Measure: " + Constants.measureLongName.EPSi.rawValue
            Utilities.setStatusIcon(status: self.equity.EPSiStatus, uiLabel: self.statusIcon)
            self.statusValueDesc.text = "(\(self.equity.EPSiStatus))"
            self.resultsLabel.text = "Result: " + String(self.equity.EPSiResult)  + "%"
            self.targetLabel.text = "Target: " + Constants.measureTargetDesc.EPSi.rawValue
            self.measureCalcDescLabel.text = "Description: "  + Constants.measureCalcDesc.EPSi.rawValue
            
        } else if measureShortName == "EPSv" {
            self.measureLongNameLabel.text = "Measure: " + Constants.measureLongName.EPSv.rawValue
            Utilities.setStatusIcon(status: self.equity.EPSvStatus, uiLabel: self.statusIcon)
            self.statusValueDesc.text = "(\(self.equity.EPSvStatus))"
            self.resultsLabel.text = "Result: \(self.equity.EPSvResult)"
            self.targetLabel.text = "Target: " + Constants.measureTargetDesc.EPSv.rawValue
            self.measureCalcDescLabel.text = "Description: "  + Constants.measureCalcDesc.EPSv.rawValue
            
        } else if measureShortName == "BVi" {
            self.measureLongNameLabel.text = "Measure: " + Constants.measureLongName.BVi.rawValue
            Utilities.setStatusIcon(status: self.equity.BViStatus, uiLabel: self.statusIcon)
            self.statusValueDesc.text = "(\(self.equity.BViStatus))"
            self.resultsLabel.text = "Result: " + String(self.equity.BViResult)  + "%"
            self.targetLabel.text = "Target: " + Constants.measureTargetDesc.BVi.rawValue
            self.measureCalcDescLabel.text = "Description: "  + Constants.measureCalcDesc.BVi.rawValue
            
        } else if measureShortName == "DRa" {
            self.measureLongNameLabel.text = "Measure: " + Constants.measureLongName.DRa.rawValue
            Utilities.setStatusIcon(status: self.equity.DRaStatus, uiLabel: self.statusIcon)
            self.statusValueDesc.text = "(\(self.equity.DRaStatus))"
            self.resultsLabel.text = "Result: " + String(self.equity.DRaResult)  + "%"
            self.targetLabel.text = "Target: " + Constants.measureTargetDesc.DRa.rawValue
            self.measureCalcDescLabel.text = "Description: "  + Constants.measureCalcDesc.DRa.rawValue
            
        } else if measureShortName == "SOr" {
            self.measureLongNameLabel.text = "Measure: " + Constants.measureLongName.SOr.rawValue
            Utilities.setStatusIcon(status: self.equity.SOrStatus, uiLabel: self.statusIcon)
            self.statusValueDesc.text = "(\(self.equity.SOrStatus))"
            self.resultsLabel.text = "Result: " + String(self.equity.SOrResult)  + "%"
            self.targetLabel.text = "Target: " + Constants.measureTargetDesc.SOr.rawValue
            self.measureCalcDescLabel.text = "Description: "  + Constants.measureCalcDesc.SOr.rawValue
            
        } else if measureShortName == "previousROI" {
            self.measureLongNameLabel.text = "Measure: " + Constants.measureLongName.previousROI.rawValue
            Utilities.setStatusIcon(status: self.equity.previousROIStatus, uiLabel: self.statusIcon)
            self.statusValueDesc.text = "(\(self.equity.previousROIStatus))"
            self.resultsLabel.text = "Result: " + String(self.equity.previousROIResult)  + "%"
            self.targetLabel.text = "Target: " + Constants.measureTargetDesc.previousROI.rawValue
            self.measureCalcDescLabel.text = "Description: "  + Constants.measureCalcDesc.previousROI.rawValue

        } else if measureShortName == "expectedROI" {
            self.measureLongNameLabel.text = "Measure: " + Constants.measureLongName.expectedROI.rawValue
            Utilities.setStatusIcon(status: self.equity.expectedROIStatus, uiLabel: self.statusIcon)
            self.statusValueDesc.text = "(\(self.equity.expectedROIStatus))"
            self.resultsLabel.text = "Result: " + String(self.equity.expectedROIResult)  + "%"
            self.targetLabel.text = "Target: " + Constants.measureTargetDesc.expectedROI.rawValue
            self.measureCalcDescLabel.text = "Description: "  + Constants.measureCalcDesc.expectedROI.rawValue
            
        } else if measureShortName == "q1" {
            self.measureLongNameLabel.text = Constants.measureLongName.q1.rawValue
        } else if measureShortName == "q2" {
            self.measureLongNameLabel.text = Constants.measureLongName.q2.rawValue
        } else if measureShortName == "q2" {
            self.measureLongNameLabel.text = Constants.measureLongName.q2.rawValue
        } else if measureShortName == "q3" {
            self.measureLongNameLabel.text = Constants.measureLongName.q3.rawValue
        } else if measureShortName == "q4" {
            self.measureLongNameLabel.text = Constants.measureLongName.q4.rawValue
        } else if measureShortName == "q5" {
            self.measureLongNameLabel.text = Constants.measureLongName.q5.rawValue
        } else {
            self.measureLongNameLabel.text = Constants.measureLongName.q6.rawValue
        }
    }
}
