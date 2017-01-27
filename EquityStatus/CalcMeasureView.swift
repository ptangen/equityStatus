//
//  CalcMeasureView.swift
//  EquityStatus
//
//  Created by Paul Tangen on 1/27/17.
//  Copyright © 2017 Paul Tangen. All rights reserved.
//

import UIKit

class CalcMeasureView: UIView {

    weak var delegate: MeasureDetailViewDelegate?
    let store = DataStore.sharedInstance
    var measureTicker = String()
    var equity: Equity!
    var measureShortName = String()
    var measureLongNameLabel = UILabel()
    var statusLabel = UILabel()
    var statusIcon = UILabel()
    var statusValueDesc = UILabel()
    var resultsLabel = UILabel()
    var targetLabel = UILabel()
    var measureCalcDescLabel = UILabel()
    var qStatusPicker = UISegmentedControl()
    
    override init(frame:CGRect){
        super.init(frame: frame)
        self.pageLayout()
        
        // configure segmented control to pick status for the measure
        self.qStatusPicker.insertSegment(withTitle: Constants.iconLibrary.faCircleO.rawValue, at: 0, animated: true)
        self.qStatusPicker.insertSegment(withTitle: Constants.iconLibrary.faCheckCircle.rawValue, at: 1, animated: true)
        self.qStatusPicker.insertSegment(withTitle: Constants.iconLibrary.faTimesCircle.rawValue, at: 2, animated: true)
        self.qStatusPicker.setTitleTextAttributes([ NSFontAttributeName: UIFont(name: Constants.iconFont.fontAwesome.rawValue, size: Constants.iconSize.small.rawValue)! ], for: .normal)
        
        let segmentButtonWidth = UIScreen.main.bounds.width / 4
        self.qStatusPicker.setWidth(segmentButtonWidth, forSegmentAt: 0)
        self.qStatusPicker.setWidth(segmentButtonWidth, forSegmentAt: 1)
        self.qStatusPicker.setWidth(segmentButtonWidth, forSegmentAt: 2)
        self.qStatusPicker.tintColor = UIColor(named: .blue)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
    
    func pageLayout() {
        // measureLongNameLabel
        self.addSubview(self.measureLongNameLabel)
        self.measureLongNameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.measureLongNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 100).isActive = true
        self.measureLongNameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        self.measureLongNameLabel.preferredMaxLayoutWidth = UIScreen.main.bounds.width - 20
        self.measureLongNameLabel.font = UIFont(name: Constants.appFont.regular.rawValue, size: Constants.fontSize.small.rawValue)
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
        
        // statusValueDesc
        self.addSubview(self.statusValueDesc)
        self.statusValueDesc.translatesAutoresizingMaskIntoConstraints = false
        self.statusValueDesc.topAnchor.constraint(equalTo: self.statusIcon.topAnchor, constant: 0).isActive = true
        self.statusValueDesc.leftAnchor.constraint(equalTo: self.statusIcon.rightAnchor, constant: 8).isActive = true
        self.statusValueDesc.font = UIFont(name: Constants.appFont.regular.rawValue, size: Constants.fontSize.small.rawValue)
        
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
    
    func setResultsLabelsForMeasure(fullString: String) {
        
        self.statusLabel.text = "Status:"
        self.measureShortName = Utilities.getMeasureName(fullString: fullString)

        // get the measure results and set the label text
        if self.measureShortName == "ROEa" {
            self.measureLongNameLabel.text = "Measure: \(Constants.measureMetadata.longName(.ROEa)())"
            Utilities.setStatusIcon(status: self.equity.ROEaStatus, uiLabel: self.statusIcon)
            self.statusValueDesc.text = "(" + getStatusDesc(self.equity.ROEaStatus) + ")"
            self.resultsLabel.text = "Result: " + getResultString(resultDouble: self.equity.ROEaResult, percentage: true)
            self.targetLabel.text = Constants.measureMetadata.threshold(.ROEa)()
            self.measureCalcDescLabel.text = Constants.measureMetadata.calcDesc(.ROEa)()
            
        } else if self.measureShortName == "EPSi" {
            self.measureLongNameLabel.text = "Measure: \(Constants.measureMetadata.longName(.EPSi)())"
            Utilities.setStatusIcon(status: self.equity.EPSiStatus, uiLabel: self.statusIcon)
            self.statusValueDesc.text = "(" + getStatusDesc(self.equity.EPSiStatus) + ")"
            self.resultsLabel.text = "Result: " + getResultString(resultDouble: self.equity.EPSiResult, percentage: true)
            self.targetLabel.text = Constants.measureMetadata.threshold(.EPSi)()
            self.measureCalcDescLabel.text = Constants.measureMetadata.calcDesc(.EPSi)()
            
        } else if self.measureShortName == "EPSv" {
            self.measureLongNameLabel.text = "Measure: \(Constants.measureMetadata.longName(.EPSv)())"
            Utilities.setStatusIcon(status: self.equity.EPSvStatus, uiLabel: self.statusIcon)
            self.statusValueDesc.text = "(" + getStatusDesc(self.equity.EPSvStatus) + ")"
            self.resultsLabel.text = "Result: " + getResultString(resultDouble: self.equity.EPSvResult, percentage: false)
            self.targetLabel.text = Constants.measureMetadata.threshold(.EPSv)()
            self.measureCalcDescLabel.text = Constants.measureMetadata.calcDesc(.EPSv)()
            
        } else if self.measureShortName == "BVi" {
            self.measureLongNameLabel.text = "Measure: \(Constants.measureMetadata.longName(.BVi)())"
            Utilities.setStatusIcon(status: self.equity.BViStatus, uiLabel: self.statusIcon)
            self.statusValueDesc.text = "(" + getStatusDesc(self.equity.BViStatus) + ")"
            self.resultsLabel.text = "Result: " + getResultString(resultDouble: self.equity.BViResult, percentage: true)
            self.targetLabel.text = Constants.measureMetadata.threshold(.BVi)()
            self.measureCalcDescLabel.text = Constants.measureMetadata.calcDesc(.BVi)()
            
        } else if self.measureShortName == "DRa" {
            self.measureLongNameLabel.text = "Measure: \(Constants.measureMetadata.longName(.DRa)())"
            Utilities.setStatusIcon(status: self.equity.DRaStatus, uiLabel: self.statusIcon)
            self.statusValueDesc.text = "(" + getStatusDesc(self.equity.DRaStatus) + ")"
            self.resultsLabel.text = "Result: " + getResultString(resultDouble: self.equity.DRaResult, percentage: false)
            self.targetLabel.text = Constants.measureMetadata.threshold(.DRa)()
            self.measureCalcDescLabel.text = Constants.measureMetadata.calcDesc(.DRa)()
            
        } else if self.measureShortName == "SOr" {
            self.measureLongNameLabel.text = "Measure: \(Constants.measureMetadata.longName(.SOr)())"
            Utilities.setStatusIcon(status: self.equity.SOrStatus, uiLabel: self.statusIcon)
            self.statusValueDesc.text = "(" + getStatusDesc(self.equity.SOrStatus) + ")"
            self.resultsLabel.text = "Result: " + getResultString(resultDouble: self.equity.SOrResult, percentage: false)
            self.targetLabel.text = Constants.measureMetadata.threshold(.SOr)()
            self.measureCalcDescLabel.text = Constants.measureMetadata.calcDesc(.SOr)()
            
        } else if self.measureShortName == "previousROI" {
            self.measureLongNameLabel.text = "Measure: \(Constants.measureMetadata.longName(.previousROI)())"
            Utilities.setStatusIcon(status: self.equity.previousROIStatus, uiLabel: self.statusIcon)
            self.statusValueDesc.text = "(" + getStatusDesc(self.equity.previousROIStatus) + ")"
            self.resultsLabel.text = "Result: " + getResultString(resultDouble: self.equity.previousROIResult, percentage: true)
            self.targetLabel.text = Constants.measureMetadata.threshold(.previousROI)()
            self.measureCalcDescLabel.text = Constants.measureMetadata.calcDesc(.previousROI)()
            
        } else if self.measureShortName == "expectedROI" {
            self.measureLongNameLabel.text = "Measure: \(Constants.measureMetadata.longName(.expectedROI)())"
            Utilities.setStatusIcon(status: self.equity.expectedROIStatus, uiLabel: self.statusIcon)
            self.statusValueDesc.text = "(" + getStatusDesc(self.equity.expectedROIStatus) + ")"
            self.resultsLabel.text = "Result: " + getResultString(resultDouble: self.equity.expectedROIResult, percentage: true)
            self.targetLabel.text = Constants.measureMetadata.threshold(.expectedROI)()
            self.measureCalcDescLabel.text = Constants.measureMetadata.calcDesc(.expectedROI)()
            
        }
    }



}
