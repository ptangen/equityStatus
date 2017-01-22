//
//  MeasureDetailView.swift
//  EquityStatus
//
//  Created by Paul Tangen on 12/30/16.
//  Copyright © 2016 Paul Tangen. All rights reserved.
//

import UIKit

protocol MeasureDetailViewDelegate: class {
    func showAlertMessage(_: String)
}

class MeasureDetailView: UIView, UITextViewDelegate {
    
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
    var qAnswerView = UITextView()
    var qAnswerViewDidChange = false

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

        self.qStatusPicker.addTarget(self, action: #selector(self.statusValueChanged(_:)), for: .valueChanged)
        
        self.qAnswerView.delegate = self
    }
    
    func statusValueChanged(_ sender:UISegmentedControl!) {
        
        self.qAnswerView.resignFirstResponder()
        
        switch sender.selectedSegmentIndex {
        case 1:
            self.updateQStatus(status: "pass")
        case 2:
            self.updateQStatus(status: "fail")
        default:
            self.updateQStatus(status: "undefined")  // user can only set values for subjective measures so undefined is valid response
        }
    }
    
    func updateQStatus(status: String) {
        
        APIClient.setSubjectiveStatus(ticker: self.equity.ticker , question: self.measureShortName, status: status, equity: self.equity, completion: { response in

            switch response {
            case .ok:
                Utilities.setStatusIcon(status: status, uiLabel: self.statusIcon)
                self.statusValueDesc.text = "(" + self.getStatusDesc(status) + ")"
                break;
                
            case.failed, .noReply:
                self.delegate?.showAlertMessage("The server was unable to save this status change. Please forward this message to ptangen@ptangen.com")
                break;
                
            default:
                break;
            }
            self.store.resetTabValue(equity: self.equity)
        })
    }
    
    func updateQAnswer(answer: String) {
        
        APIClient.setSubjectiveAnswer(ticker: self.equity.ticker , question: self.measureShortName, answer: answer, equity: self.equity, completion: { response in
            
            switch response {
            case .ok:
                
                break;
                
            case.failed, .noReply:
                self.delegate?.showAlertMessage("The server was unable to save this status change. Please forward this message to ptangen@ptangen.com")
                break;
                
            default:
                break;
            }
        })
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
    
    func showSubjectiveMeasureControls(qStatus: String) {
        // show
        self.qStatusPicker.isHidden = false
        self.qAnswerView.isHidden = false
        
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
        self.qAnswerView.isHidden = true
    }
    
    func setTextInQAnswerView(textToDisplay: String) {
        // set the comment in the qAnswerView
        if textToDisplay.isEmpty {
            self.qAnswerView.text = "Comments"
            self.qAnswerView.textColor = UIColor(named: .disabledText)
        } else {
            self.qAnswerView.text = textToDisplay
            self.qAnswerView.textColor = UIColor.black
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor(named: .disabledText) {
            self.qAnswerView.text = nil
            self.qAnswerView.textColor = UIColor.black
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.qAnswerViewDidChange = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        // send text to the DB
        self.qAnswerViewDidChange ? self.updateQAnswer(answer: textView.text) : ()
        if textView.text.isEmpty {
            textView.text = "Comment"
            textView.textColor = UIColor(named: .disabledText)
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
        
        // qStatusPicker
        self.addSubview(self.qStatusPicker)
        self.qStatusPicker.translatesAutoresizingMaskIntoConstraints = false
        self.qStatusPicker.topAnchor.constraint(equalTo: self.statusValueDesc.bottomAnchor, constant: 40).isActive = true
        self.qStatusPicker.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.qStatusPicker.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.qStatusPicker.isHidden = true
        
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
        
        self.addSubview(self.qAnswerView)
        self.qAnswerView.translatesAutoresizingMaskIntoConstraints = false
        self.qAnswerView.topAnchor.constraint(equalTo: self.qStatusPicker.bottomAnchor, constant: 30).isActive = true
        self.qAnswerView.leftAnchor.constraint(equalTo: self.qStatusPicker.leftAnchor, constant: -30).isActive = true
        self.qAnswerView.rightAnchor.constraint(equalTo: self.qStatusPicker.rightAnchor, constant: 30).isActive = true
        self.qAnswerView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        self.qAnswerView.font = UIFont(name: Constants.appFont.regular.rawValue, size: Constants.fontSize.small.rawValue)
        self.qAnswerView.layer.borderColor = UIColor(named: .blue).cgColor
        self.qAnswerView.layer.borderWidth = 1.0
    }
    
    func setResultsLabelsForMeasure(fullString: String) {
        
        self.statusLabel.text = "Status:"
        
        // extract the measure name
        let chars = fullString.characters;
        if let indexLeftParen = chars.index(of: "(") {
            let indexBeforeLeftParen = chars.index(before: indexLeftParen)
            self.measureShortName = fullString[chars.startIndex...indexBeforeLeftParen]
        }
        
        // get the measure results and set the label text
        if self.measureShortName == "ROEa" {
            self.showObjectiveMeasureControls()
            self.measureLongNameLabel.text = "Measure: \(Constants.measureMetadata.longName(.ROEa)())"
            Utilities.setStatusIcon(status: self.equity.ROEaStatus, uiLabel: self.statusIcon)
            self.statusValueDesc.text = "(" + getStatusDesc(self.equity.ROEaStatus) + ")"
            self.resultsLabel.text = "Result: " + getResultString(resultDouble: self.equity.ROEaResult, percentage: true)
            self.targetLabel.text = Constants.measureMetadata.threshold(.ROEa)()
            self.measureCalcDescLabel.text = Constants.measureMetadata.calcDesc(.ROEa)()
            
        } else if self.measureShortName == "EPSi" {
            self.showObjectiveMeasureControls()
            self.measureLongNameLabel.text = "Measure: \(Constants.measureMetadata.longName(.EPSi)())"
            Utilities.setStatusIcon(status: self.equity.EPSiStatus, uiLabel: self.statusIcon)
            self.statusValueDesc.text = "(" + getStatusDesc(self.equity.EPSiStatus) + ")"
            self.resultsLabel.text = "Result: " + getResultString(resultDouble: self.equity.EPSiResult, percentage: true)
            self.targetLabel.text = Constants.measureMetadata.threshold(.EPSi)()
            self.measureCalcDescLabel.text = Constants.measureMetadata.calcDesc(.EPSi)()
            
        } else if self.measureShortName == "EPSv" {
            self.showObjectiveMeasureControls()
            self.measureLongNameLabel.text = "Measure: \(Constants.measureMetadata.longName(.EPSv)())"
            Utilities.setStatusIcon(status: self.equity.EPSvStatus, uiLabel: self.statusIcon)
            self.statusValueDesc.text = "(" + getStatusDesc(self.equity.EPSvStatus) + ")"
            self.resultsLabel.text = "Result: " + getResultString(resultDouble: self.equity.EPSvResult, percentage: false)
            self.targetLabel.text = Constants.measureMetadata.threshold(.EPSv)()
            self.measureCalcDescLabel.text = Constants.measureMetadata.calcDesc(.EPSv)()
            
        } else if self.measureShortName == "BVi" {
            self.showObjectiveMeasureControls()
            self.measureLongNameLabel.text = "Measure: \(Constants.measureMetadata.longName(.BVi)())"
            Utilities.setStatusIcon(status: self.equity.BViStatus, uiLabel: self.statusIcon)
            self.statusValueDesc.text = "(" + getStatusDesc(self.equity.BViStatus) + ")"
            self.resultsLabel.text = "Result: " + getResultString(resultDouble: self.equity.BViResult, percentage: true)
            self.targetLabel.text = Constants.measureMetadata.threshold(.BVi)()
            self.measureCalcDescLabel.text = Constants.measureMetadata.calcDesc(.BVi)()
            
        } else if self.measureShortName == "DRa" {
            self.showObjectiveMeasureControls()
            self.measureLongNameLabel.text = "Measure: \(Constants.measureMetadata.longName(.DRa)())"
            Utilities.setStatusIcon(status: self.equity.DRaStatus, uiLabel: self.statusIcon)
            self.statusValueDesc.text = "(" + getStatusDesc(self.equity.DRaStatus) + ")"
            self.resultsLabel.text = "Result: " + getResultString(resultDouble: self.equity.DRaResult, percentage: false)
            self.targetLabel.text = Constants.measureMetadata.threshold(.DRa)()
            self.measureCalcDescLabel.text = Constants.measureMetadata.calcDesc(.DRa)()
            
        } else if self.measureShortName == "SOr" {
            self.showObjectiveMeasureControls()
            self.measureLongNameLabel.text = "Measure: \(Constants.measureMetadata.longName(.SOr)())"
            Utilities.setStatusIcon(status: self.equity.SOrStatus, uiLabel: self.statusIcon)
            self.statusValueDesc.text = "(" + getStatusDesc(self.equity.SOrStatus) + ")"
            self.resultsLabel.text = "Result: " + getResultString(resultDouble: self.equity.SOrResult, percentage: false)
            self.targetLabel.text = Constants.measureMetadata.threshold(.SOr)()
            self.measureCalcDescLabel.text = Constants.measureMetadata.calcDesc(.SOr)()
            
        } else if self.measureShortName == "previousROI" {
            self.showObjectiveMeasureControls()
            self.measureLongNameLabel.text = "Measure: \(Constants.measureMetadata.longName(.previousROI)())"
            Utilities.setStatusIcon(status: self.equity.previousROIStatus, uiLabel: self.statusIcon)
            self.statusValueDesc.text = "(" + getStatusDesc(self.equity.previousROIStatus) + ")"
            self.resultsLabel.text = "Result: " + getResultString(resultDouble: self.equity.previousROIResult, percentage: true)
            self.targetLabel.text = Constants.measureMetadata.threshold(.previousROI)()
            self.measureCalcDescLabel.text = Constants.measureMetadata.calcDesc(.previousROI)()
            
        } else if self.measureShortName == "expectedROI" {
            self.showObjectiveMeasureControls()
            self.measureLongNameLabel.text = "Measure: \(Constants.measureMetadata.longName(.expectedROI)())"
            Utilities.setStatusIcon(status: self.equity.expectedROIStatus, uiLabel: self.statusIcon)
            self.statusValueDesc.text = "(" + getStatusDesc(self.equity.expectedROIStatus) + ")"
            self.resultsLabel.text = "Result: " + getResultString(resultDouble: self.equity.expectedROIResult, percentage: true)
            self.targetLabel.text = Constants.measureMetadata.threshold(.expectedROI)()
            self.measureCalcDescLabel.text = Constants.measureMetadata.calcDesc(.expectedROI)()
            
        } else if self.measureShortName == "q1" {
            self.showSubjectiveMeasureControls(qStatus: self.equity.q1Status)
            self.measureLongNameLabel.text = Constants.measureMetadata.longName(.q1)()
            Utilities.setStatusIcon(status: self.equity.q1Status, uiLabel: self.statusIcon)
            self.statusValueDesc.text = "(" + getStatusDesc(self.equity.q1Status) + ")"
            self.setTextInQAnswerView(textToDisplay: self.equity.q1Answer)
            
        } else if self.measureShortName == "q2" {
            self.showSubjectiveMeasureControls(qStatus: self.equity.q2Status)
            self.measureLongNameLabel.text = Constants.measureMetadata.longName(.q2)()
            Utilities.setStatusIcon(status: self.equity.q2Status, uiLabel: self.statusIcon)
            self.statusValueDesc.text = "(" + getStatusDesc(self.equity.q2Status) + ")"
            self.setTextInQAnswerView(textToDisplay: self.equity.q2Answer)
            
        } else if self.measureShortName == "q3" {
            self.showSubjectiveMeasureControls(qStatus: self.equity.q3Status)
            self.measureLongNameLabel.text = Constants.measureMetadata.longName(.q3)()
            Utilities.setStatusIcon(status: self.equity.q3Status, uiLabel: self.statusIcon)
            self.statusValueDesc.text = "(" + getStatusDesc(self.equity.q3Status) + ")"
            self.setTextInQAnswerView(textToDisplay: self.equity.q3Answer)
            
        } else if self.measureShortName == "q4" {
            self.showSubjectiveMeasureControls(qStatus: self.equity.q4Status)
            self.measureLongNameLabel.text = Constants.measureMetadata.longName(.q4)()
            Utilities.setStatusIcon(status: self.equity.q4Status, uiLabel: self.statusIcon)
            self.statusValueDesc.text = "(" + getStatusDesc(self.equity.q4Status) + ")"
            self.setTextInQAnswerView(textToDisplay: self.equity.q4Answer)
            
        } else if self.measureShortName == "q5" {
            self.showSubjectiveMeasureControls(qStatus: self.equity.q5Status)
            self.measureLongNameLabel.text = Constants.measureMetadata.longName(.q5)()
            Utilities.setStatusIcon(status: self.equity.q5Status, uiLabel: self.statusIcon)
            self.statusValueDesc.text = "(" + getStatusDesc(self.equity.q5Status) + ")"
            self.setTextInQAnswerView(textToDisplay: self.equity.q5Answer)
            
        } else {
            self.showSubjectiveMeasureControls(qStatus: self.equity.q6Status)
            self.measureLongNameLabel.text = Constants.measureMetadata.longName(.q6)()
            Utilities.setStatusIcon(status: self.equity.q6Status, uiLabel: self.statusIcon)
            self.statusValueDesc.text = "(" + getStatusDesc(self.equity.q6Status) + ")"
            self.setTextInQAnswerView(textToDisplay: self.equity.q6Answer)
        }
    }
}
