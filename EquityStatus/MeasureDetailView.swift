//
//  MeasureDetailView.swift
//  EquityStatus
//
//  Created by Paul Tangen on 12/30/16.
//  Copyright © 2016 Paul Tangen. All rights reserved.
//

import UIKit

class MeasureDetailView: UIView {
    
    let store = DataStore.sharedInstance
    var measureTicker: String = String()
    var equity: Equity!
    var measureShortName: String = String()
    var measureLongNameLabel: UILabel = UILabel()
    var statusLabel: UILabel = UILabel()
    var statusIcon: UILabel = UILabel()
    var statusValueDesc: UILabel = UILabel()
    var resultsLabel: UILabel = UILabel()
    var targetLabel: UILabel = UILabel()
    var measureCalcDescLabel: UILabel = UILabel()
    var qStatusPicker: UISegmentedControl = UISegmentedControl()

    override init(frame:CGRect){
        super.init(frame: frame)
        self.pageLayout()
        
        self.qStatusPicker.insertSegment(withTitle: Constants.iconLibrary.faCircleO.rawValue, at: 0, animated: true)
        self.qStatusPicker.insertSegment(withTitle: Constants.iconLibrary.faCheckCircle.rawValue, at: 1, animated: true)
        self.qStatusPicker.insertSegment(withTitle: Constants.iconLibrary.faTimesCircle.rawValue, at: 2, animated: true)
        self.qStatusPicker.setTitleTextAttributes([ NSFontAttributeName: UIFont(name: Constants.iconFont.fontAwesome.rawValue , size: CGFloat(Constants.iconSize.small.rawValue))! ], for: .normal)
        //self.qStatusPicker.tintColor = UIColor(named: UIColor.ColorName.statusGreen)

        // Add function to handle Value Changed events
        qStatusPicker.addTarget(self, action: #selector(self.statusValueChanged(_:)), for: .valueChanged)
    }
    
    func statusValueChanged(_ sender:UISegmentedControl!) {
        print("Selected Segment Index is : \(sender.selectedSegmentIndex)")
        switch sender.selectedSegmentIndex {
        case 1: // pass
            print("set to pass")
            self.updateQStatus(status: "pass")
        case 2: // fail
            print("set to fail")
            self.updateQStatus(status: "fail")
        default:
            print("set to undefined")
            self.updateQStatus(status: "undefined")
        }
    }
    
    func updateQStatus(status: String) {
        
        switch self.measureShortName {
        case "q1": self.equity.q1Status = status
        case "q2": self.equity.q2Status = status
        case "q3": self.equity.q3Status = status
        case "q4": self.equity.q4Status = status
        case "q5": self.equity.q5Status = status
        case "q6": self.equity.q6Status = status
        default: print("error 121")
        }
        // update the status fields in the UI to match the segmented control
        Utilities.setStatusIcon(status: status, uiLabel: self.statusIcon)
        self.statusValueDesc.text = "(" + getStatusDesc(status) + ")"
        // update DB ...
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
        self.measureLongNameLabel.numberOfLines = 0
        
        // statusLabel
        self.addSubview(self.statusLabel)
        self.statusLabel.translatesAutoresizingMaskIntoConstraints = false
        self.statusLabel.topAnchor.constraint(equalTo: self.measureLongNameLabel.bottomAnchor, constant: 10).isActive = true
        self.statusLabel.leftAnchor.constraint(equalTo: self.measureLongNameLabel.leftAnchor).isActive = true
        self.statusLabel.font = UIFont(name: Constants.appFont.regular.rawValue, size: Constants.fontSize.small.rawValue)
        
        // statusIcon
        self.addSubview(self.statusIcon)
        self.statusIcon.translatesAutoresizingMaskIntoConstraints = false
        self.statusIcon.topAnchor.constraint(equalTo: self.statusLabel.topAnchor, constant: 2).isActive = true
        self.statusIcon.leftAnchor.constraint(equalTo: self.statusLabel.rightAnchor, constant: 8).isActive = true
        self.statusIcon.font = UIFont(name: Constants.iconFont.fontAwesome.rawValue, size: Constants.fontSize.small.rawValue)
        
        // statusValueDesc
        self.addSubview(self.statusValueDesc)
        self.statusValueDesc.translatesAutoresizingMaskIntoConstraints = false
        self.statusValueDesc.topAnchor.constraint(equalTo: self.statusIcon.topAnchor, constant: -2).isActive = true
        self.statusValueDesc.leftAnchor.constraint(equalTo: self.statusIcon.rightAnchor, constant: 8).isActive = true
        //self.statusValueDesc.rightAnchor.constraint(equalTo: self.measureLongNameLabel.rightAnchor).isActive = true
        self.statusValueDesc.font = UIFont(name: Constants.appFont.regular.rawValue, size: Constants.fontSize.small.rawValue)
        
        // qStatusPicker
        self.addSubview(self.qStatusPicker)
        self.qStatusPicker.translatesAutoresizingMaskIntoConstraints = false
        self.qStatusPicker.topAnchor.constraint(equalTo: self.statusValueDesc.bottomAnchor, constant: 20).isActive = true
        self.qStatusPicker.leftAnchor.constraint(equalTo: self.statusLabel.leftAnchor).isActive = true
        self.qStatusPicker.rightAnchor.constraint(equalTo: self.measureLongNameLabel.rightAnchor).isActive = true
        self.qStatusPicker.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.qStatusPicker.isHidden = true
        
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
        self.measureShortName = fullString[chars.startIndex...indexBeforeLeftParen]
        
        // get the measure results and set the label text
        if self.measureShortName == "ROEa" {
            self.showObjectiveMeasureControls()
            self.measureLongNameLabel.text = "Measure: " + Constants.measureLongName.ROEa.rawValue
            Utilities.setStatusIcon(status: self.equity.ROEaStatus, uiLabel: self.statusIcon)
            self.statusValueDesc.text = "(" + getStatusDesc(self.equity.ROEaStatus) + ")"
            self.resultsLabel.text = "Result: " + getResultString(resultDouble: self.equity.ROEaResult, percentage: true)
            self.targetLabel.text = "Target: " + Constants.measureTargetDesc.ROEa.rawValue
            self.measureCalcDescLabel.text = "Description: "  + Constants.measureCalcDesc.ROEa.rawValue
            
        } else if self.measureShortName == "EPSi" {
            self.showObjectiveMeasureControls()
            self.measureLongNameLabel.text = "Measure: " + Constants.measureLongName.EPSi.rawValue
            Utilities.setStatusIcon(status: self.equity.EPSiStatus, uiLabel: self.statusIcon)
            self.statusValueDesc.text = "(" + getStatusDesc(self.equity.EPSiStatus) + ")"
            self.resultsLabel.text = "Result: " + getResultString(resultDouble: self.equity.EPSiResult, percentage: true)
            self.targetLabel.text = "Target: " + Constants.measureTargetDesc.EPSi.rawValue
            self.measureCalcDescLabel.text = "Description: "  + Constants.measureCalcDesc.EPSi.rawValue
            
        } else if self.measureShortName == "EPSv" {
            self.showObjectiveMeasureControls()
            self.measureLongNameLabel.text = "Measure: " + Constants.measureLongName.EPSv.rawValue
            Utilities.setStatusIcon(status: self.equity.EPSvStatus, uiLabel: self.statusIcon)
            self.statusValueDesc.text = "(" + getStatusDesc(self.equity.EPSvStatus) + ")"
            self.resultsLabel.text = "Result: " + getResultString(resultDouble: self.equity.EPSvResult, percentage: false)
            self.targetLabel.text = "Target: " + Constants.measureTargetDesc.EPSv.rawValue
            self.measureCalcDescLabel.text = "Description: "  + Constants.measureCalcDesc.EPSv.rawValue
            
        } else if self.measureShortName == "BVi" {
            self.showObjectiveMeasureControls()
            self.measureLongNameLabel.text = "Measure: " + Constants.measureLongName.BVi.rawValue
            Utilities.setStatusIcon(status: self.equity.BViStatus, uiLabel: self.statusIcon)
            self.statusValueDesc.text = "(" + getStatusDesc(self.equity.BViStatus) + ")"
            self.resultsLabel.text = "Result: " + getResultString(resultDouble: self.equity.BViResult, percentage: true)
            self.targetLabel.text = "Target: " + Constants.measureTargetDesc.BVi.rawValue
            self.measureCalcDescLabel.text = "Description: "  + Constants.measureCalcDesc.BVi.rawValue
            
        } else if self.measureShortName == "DRa" {
            self.showObjectiveMeasureControls()
            self.measureLongNameLabel.text = "Measure: " + Constants.measureLongName.DRa.rawValue
            Utilities.setStatusIcon(status: self.equity.DRaStatus, uiLabel: self.statusIcon)
            self.statusValueDesc.text = "(" + getStatusDesc(self.equity.DRaStatus) + ")"
            self.resultsLabel.text = "Result: " + getResultString(resultDouble: self.equity.DRaResult, percentage: false)
            self.targetLabel.text = "Target: " + Constants.measureTargetDesc.DRa.rawValue
            self.measureCalcDescLabel.text = "Description: "  + Constants.measureCalcDesc.DRa.rawValue
            
        } else if self.measureShortName == "SOr" {
            self.showObjectiveMeasureControls()
            self.measureLongNameLabel.text = "Measure: " + Constants.measureLongName.SOr.rawValue
            Utilities.setStatusIcon(status: self.equity.SOrStatus, uiLabel: self.statusIcon)
            self.statusValueDesc.text = "(" + getStatusDesc(self.equity.SOrStatus) + ")"
            self.resultsLabel.text = "Result: " + getResultString(resultDouble: self.equity.SOrResult, percentage: false)
            self.targetLabel.text = "Target: " + Constants.measureTargetDesc.SOr.rawValue
            self.measureCalcDescLabel.text = "Description: "  + Constants.measureCalcDesc.SOr.rawValue
            
        } else if self.measureShortName == "previousROI" {
            self.showObjectiveMeasureControls()
            self.measureLongNameLabel.text = "Measure: " + Constants.measureLongName.previousROI.rawValue
            Utilities.setStatusIcon(status: self.equity.previousROIStatus, uiLabel: self.statusIcon)
            self.statusValueDesc.text = "(" + getStatusDesc(self.equity.previousROIStatus) + ")"
            self.resultsLabel.text = "Result: " + getResultString(resultDouble: self.equity.previousROIResult, percentage: true)
            self.targetLabel.text = "Target: " + Constants.measureTargetDesc.previousROI.rawValue
            self.measureCalcDescLabel.text = "Description: "  + Constants.measureCalcDesc.previousROI.rawValue

        } else if self.measureShortName == "expectedROI" {
            self.showObjectiveMeasureControls()
            self.measureLongNameLabel.text = "Measure: " + Constants.measureLongName.expectedROI.rawValue
            Utilities.setStatusIcon(status: self.equity.expectedROIStatus, uiLabel: self.statusIcon)
            self.statusValueDesc.text = "(" + getStatusDesc(self.equity.expectedROIStatus) + ")"
            self.resultsLabel.text = "Result: " + getResultString(resultDouble: self.equity.expectedROIResult, percentage: true)
            self.targetLabel.text = "Target: " + Constants.measureTargetDesc.expectedROI.rawValue
            self.measureCalcDescLabel.text = "Description: "  + Constants.measureCalcDesc.expectedROI.rawValue
            
        } else if self.measureShortName == "q1" {
            self.showSubjectiveMeasureControls(qStatus: self.equity.q1Status)
            self.measureLongNameLabel.text = Constants.measureLongName.q1.rawValue
            Utilities.setStatusIcon(status: self.equity.q1Status, uiLabel: self.statusIcon)
            self.statusValueDesc.text = "(" + getStatusDesc(self.equity.q1Status) + ")"
            
        } else if self.measureShortName == "q2" {
            self.showSubjectiveMeasureControls(qStatus: self.equity.q2Status)
            self.measureLongNameLabel.text = Constants.measureLongName.q2.rawValue
            Utilities.setStatusIcon(status: self.equity.q2Status, uiLabel: self.statusIcon)
            self.statusValueDesc.text = "(" + getStatusDesc(self.equity.q2Status) + ")"
            
        } else if self.measureShortName == "q3" {
            self.showSubjectiveMeasureControls(qStatus: self.equity.q3Status)
            self.measureLongNameLabel.text = Constants.measureLongName.q3.rawValue
            Utilities.setStatusIcon(status: self.equity.q3Status, uiLabel: self.statusIcon)
            self.statusValueDesc.text = "(" + getStatusDesc(self.equity.q3Status) + ")"
            
        } else if self.measureShortName == "q4" {
            self.showSubjectiveMeasureControls(qStatus: self.equity.q4Status)
            self.measureLongNameLabel.text = Constants.measureLongName.q4.rawValue
            Utilities.setStatusIcon(status: self.equity.q4Status, uiLabel: self.statusIcon)
            self.statusValueDesc.text = "(" + getStatusDesc(self.equity.q4Status) + ")"
            
        } else if self.measureShortName == "q5" {
            self.showSubjectiveMeasureControls(qStatus: self.equity.q5Status)
            self.measureLongNameLabel.text = Constants.measureLongName.q5.rawValue
            Utilities.setStatusIcon(status: self.equity.q5Status, uiLabel: self.statusIcon)
            self.statusValueDesc.text = "(" + getStatusDesc(self.equity.q5Status) + ")"
            
        } else {
            self.showSubjectiveMeasureControls(qStatus: self.equity.q6Status)
            self.measureLongNameLabel.text = Constants.measureLongName.q6.rawValue
            Utilities.setStatusIcon(status: self.equity.q6Status, uiLabel: self.statusIcon)
            self.statusValueDesc.text = "(" + getStatusDesc(self.equity.q6Status) + ")"
        }
    }
    
    func getResultString(resultDouble: Double, percentage: Bool) -> String {
        if resultDouble == -1000 {
            return "no data"
        } else {
            if percentage == true {
                return String(resultDouble) + "%"
            } else {
                return String(resultDouble)
            }
        }
    }
    
    func getStatusDesc(_ statusDesc: String) -> String {
        if statusDesc == "noData" {
            return "no data"
        } else {
            return statusDesc;
        }
    }
    
    func showSubjectiveMeasureControls(qStatus: String) {
        // show
        self.qStatusPicker.isHidden = false
        
        // set status on button bar
        switch qStatus {
        case "pass":
            self.qStatusPicker.selectedSegmentIndex = 1
        case "fail":
            self.qStatusPicker.selectedSegmentIndex = 2
        default:
            self.qStatusPicker.selectedSegmentIndex = 0
        }
        
        // hide
        self.resultsLabel.isHidden = true
        self.targetLabel.isHidden = true
        self.measureCalcDescLabel.isHidden = true
    }
    
    func showObjectiveMeasureControls() {
        // show
        self.resultsLabel.isHidden = false
        self.targetLabel.isHidden = false
        self.measureCalcDescLabel.isHidden = false
    
        // hide
        self.qStatusPicker.isHidden = true
    }
}