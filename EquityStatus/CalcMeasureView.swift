//
//  CalcMeasureView.swift
//  EquityStatus
//
//  Created by Paul Tangen on 1/27/17.
//  Copyright © 2017 Paul Tangen. All rights reserved.
//

import UIKit
import Charts

protocol MeasureDetailViewDelegate: class {
    func showAlertMessage(_: String)
}

class CalcMeasureView: UIView, ChartViewDelegate {

    weak var delegate: MeasureDetailViewDelegate?
    let store = DataStore.sharedInstance
    var company: Company!
    var measure = String()
    var measureShortName = String()
    var measureLongNameLabel = UILabel()
    var statusLabel = UILabel()
    var statusIcon = UILabel()
    var resultsLabel = UILabel()
    var targetLabel = UILabel()
    var measureCalcDescLabel = UILabel()
    
    override init(frame:CGRect){
        super.init(frame: frame)
        self.pageLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func getResultString(resultDouble: Double, percentage: Bool) -> String {
        if percentage == true {
            return String(resultDouble) + "%"
        } else {
            return String(resultDouble)
        }
    }
    
    func getStatusDesc(passed: Bool?) -> String {
        if let passedUnwrapped = passed {
            return String(passedUnwrapped)
        }
        return ""
    }
    
    func pageLayout() {
        // measureLongNameLabel
        self.addSubview(self.measureLongNameLabel)
        self.measureLongNameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.measureLongNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 30).isActive = true
        self.measureLongNameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        self.measureLongNameLabel.preferredMaxLayoutWidth = UIScreen.main.bounds.width - 20
        self.measureLongNameLabel.font = UIFont(name: Constants.appFont.bold.rawValue, size: Constants.fontSize.small.rawValue)
        self.measureLongNameLabel.numberOfLines = 0
        
        // statusLabel
        self.addSubview(self.statusLabel)
        self.statusLabel.translatesAutoresizingMaskIntoConstraints = false
        self.statusLabel.topAnchor.constraint(equalTo: self.measureLongNameLabel.bottomAnchor, constant: 30).isActive = true
        self.statusLabel.leftAnchor.constraint(equalTo: self.measureLongNameLabel.leftAnchor).isActive = true
        self.statusLabel.font = UIFont(name: Constants.appFont.regular.rawValue, size: Constants.fontSize.small.rawValue)
        
        // statusIcon
        self.addSubview(self.statusIcon)
        self.statusIcon.translatesAutoresizingMaskIntoConstraints = false
        self.statusIcon.topAnchor.constraint(equalTo: self.statusLabel.topAnchor, constant: 0).isActive = true
        self.statusIcon.leftAnchor.constraint(equalTo: self.statusLabel.rightAnchor, constant: 8).isActive = true
        self.statusIcon.font = UIFont(name: Constants.iconFont.fontAwesome.rawValue, size: Constants.iconSize.xsmall.rawValue)
        
        // resultsLabel
        self.addSubview(self.resultsLabel)
        self.resultsLabel.translatesAutoresizingMaskIntoConstraints = false
        self.resultsLabel.topAnchor.constraint(equalTo: self.statusLabel.bottomAnchor, constant: 30).isActive = true
        self.resultsLabel.leftAnchor.constraint(equalTo: self.statusLabel.leftAnchor).isActive = true
        self.resultsLabel.rightAnchor.constraint(equalTo: self.measureLongNameLabel.rightAnchor).isActive = true
        self.resultsLabel.font = UIFont(name: Constants.appFont.regular.rawValue, size: Constants.fontSize.small.rawValue)
        
        // targetLabel
        self.addSubview(self.targetLabel)
        self.targetLabel.translatesAutoresizingMaskIntoConstraints = false
        self.targetLabel.topAnchor.constraint(equalTo: self.resultsLabel.bottomAnchor, constant: 30).isActive = true
        self.targetLabel.leftAnchor.constraint(equalTo: self.resultsLabel.leftAnchor).isActive = true
        self.targetLabel.rightAnchor.constraint(equalTo: self.resultsLabel.rightAnchor).isActive = true
        self.targetLabel.font = UIFont(name: Constants.appFont.regular.rawValue, size: Constants.fontSize.small.rawValue)
        
        // measureCalcDescLabel
        self.addSubview(self.measureCalcDescLabel)
        self.measureCalcDescLabel.translatesAutoresizingMaskIntoConstraints = false
        self.measureCalcDescLabel.topAnchor.constraint(equalTo: self.targetLabel.bottomAnchor, constant: 30).isActive = true
        self.measureCalcDescLabel.leftAnchor.constraint(equalTo: self.targetLabel.leftAnchor).isActive = true
        self.measureCalcDescLabel.rightAnchor.constraint(equalTo: self.targetLabel.rightAnchor).isActive = true
        self.measureCalcDescLabel.font = UIFont(name: Constants.appFont.regular.rawValue, size: Constants.fontSize.small.rawValue)
        self.measureCalcDescLabel.preferredMaxLayoutWidth = UIScreen.main.bounds.width - 20
        self.measureCalcDescLabel.numberOfLines = 0
    }
    
    func getMeasureResultsAndSetLabelText(passed: Bool, value: Double, percentage: Bool, longName: String, targetLabel: String, measureCalcDescLabel: String) {
        self.measureLongNameLabel.text = longName
        Utilities.getStatusIcon(status: passed, uiLabel: self.statusIcon)
        self.resultsLabel.text = "Result: " + getResultString(resultDouble: value, percentage: percentage)
        self.targetLabel.text = targetLabel
        self.measureCalcDescLabel.text = measureCalcDescLabel
    }
    
    func setResultsLabelsForMeasure(measure: String) {
        
        self.statusLabel.text = "Status:"
        let measureInfo = self.store.measureInfo[measure]!
    
        switch measure {
            case "roe_avg":
                if let roe_avg_passed = self.company.roe_avg_passed, let roe_avg = self.company.roe_avg {
                    self.getMeasureResultsAndSetLabelText(passed: roe_avg_passed, value: Double(roe_avg), percentage: true,
                        longName: measureInfo["longName"]!,
                        targetLabel: measureInfo["thresholdDesc"]!,
                        measureCalcDescLabel: measureInfo["calcDesc"]!)
            }
            
        case "eps_i":
            if let eps_i_passed = self.company.eps_i_passed, let eps_i = self.company.eps_i {
                self.getMeasureResultsAndSetLabelText(passed: eps_i_passed, value: Double(eps_i), percentage: true,
                    longName: measureInfo["longName"]!,
                    targetLabel: measureInfo["thresholdDesc"]!,
                    measureCalcDescLabel: measureInfo["calcDesc"]!)
            }
            
        case "eps_sd":
            if let eps_sd_passed = self.company.eps_sd_passed, let eps_sd = self.company.eps_sd {
                self.getMeasureResultsAndSetLabelText(passed: eps_sd_passed, value: eps_sd, percentage: false,
                    longName: measureInfo["longName"]!,
                    targetLabel: measureInfo["thresholdDesc"]!,
                    measureCalcDescLabel: measureInfo["calcDesc"]!)
            }
            
        case "bv_i":
            if let bv_i_passed = self.company.bv_i_passed, let bv_i = self.company.bv_i {
                self.getMeasureResultsAndSetLabelText(passed: bv_i_passed, value: Double(bv_i), percentage: true,
                    longName: measureInfo["longName"]!,
                    targetLabel: measureInfo["thresholdDesc"]!,
                    measureCalcDescLabel: measureInfo["calcDesc"]!)
            }
            
        case "dr_avg":
            if let dr_avg_passed = self.company.dr_avg_passed, let dr_avg = self.company.dr_avg {
                self.getMeasureResultsAndSetLabelText(passed: dr_avg_passed, value: Double(dr_avg), percentage: false,
                    longName: measureInfo["longName"]!,
                    targetLabel: measureInfo["thresholdDesc"]!,
                    measureCalcDescLabel: measureInfo["calcDesc"]!)
            }
            
        case "so_reduced":
            if let so_reduced_passed = self.company.so_reduced_passed, let so_reduced = self.company.so_reduced {
                self.getMeasureResultsAndSetLabelText(passed: so_reduced_passed, value: Double(so_reduced), percentage: false, longName: measureInfo["longName"]!,
                    targetLabel: measureInfo["thresholdDesc"]!,
                    measureCalcDescLabel: measureInfo["calcDesc"]!)
            }
            
        case "previous_roi":
            if let previous_roi_passed = self.company.previous_roi_passed, let previous_roi = self.company.previous_roi {
                self.getMeasureResultsAndSetLabelText(passed: previous_roi_passed, value: Double(previous_roi), percentage: true, longName: measureInfo["longName"]!,
                    targetLabel: measureInfo["thresholdDesc"]!,
                    measureCalcDescLabel: measureInfo["calcDesc"]!)
            }
            
        case "expected_roi":
            if let expected_roi_passed = self.company.expected_roi_passed, let expected_roi = self.company.expected_roi {
                self.getMeasureResultsAndSetLabelText(passed: expected_roi_passed, value: Double(expected_roi), percentage: true, longName: measureInfo["longName"]!,
                    targetLabel: measureInfo["thresholdDesc"]!,
                    measureCalcDescLabel: measureInfo["calcDesc"]!)
            }
            
        default: break
        }
    }
}
