//
//  QuestionMeasureView.swift
//  EquityStatus
//
//  Created by Paul Tangen on 1/27/17.
//  Copyright © 2017 Paul Tangen. All rights reserved.
//

import UIKit

class QuestionMeasureView: UIView, UITextViewDelegate {

    weak var delegate: MeasureDetailViewDelegate?
    let store = DataStore.sharedInstance
    var measureTicker = String()
    var equity: Equity!
    var measureShortName = String()
    var measureLongNameLabel = UILabel()
    var statusLabel = UILabel()
    var statusIcon = UILabel()
    var statusValueDesc = UILabel()
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
        
        APIClient.setSubjectiveStatus(question: self.measureShortName, status: status, equity: self.equity, completion: { response in
            
            switch response {
            case .ok:
                Utilities.setStatusIcon(status: status, uiLabel: self.statusIcon)
                self.statusValueDesc.text = "(" + self.getStatusDesc(status) + ")"
                
                // udpate the status in the equity
                switch self.measureShortName {
                case "q1":
                    self.equity.q1Status = status
                case "q2":
                    self.equity.q2Status = status
                case "q3":
                    self.equity.q3Status = status
                case "q4":
                    self.equity.q4Status = status
                case "q5":
                    self.equity.q5Status = status
                case "q6":
                    self.equity.q6Status = status
                default:
                    break
                }
                
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
        
        APIClient.setSubjectiveAnswer(question: self.measureShortName, answer: answer, equity: self.equity, completion: { response in
            
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
    
    func getMeasureResultsAndSetLabelText(status: String, longName: String, answer: String) {
        self.showSubjectiveMeasureControls(qStatus: status)
        self.measureLongNameLabel.text = longName
        Utilities.setStatusIcon(status: status, uiLabel: self.statusIcon)
        self.statusValueDesc.text = "(" + getStatusDesc(status) + ")"
        self.setTextInQAnswerView(textToDisplay: answer)
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
        if self.measureShortName == "q1" {
            self.getMeasureResultsAndSetLabelText(status: self.equity.q1Status, longName: Constants.measureMetadata.longName(.q1)(), answer: self.equity.q1Answer)
            
        } else if self.measureShortName == "q2" {
            self.getMeasureResultsAndSetLabelText(status: self.equity.q2Status, longName: Constants.measureMetadata.longName(.q2)(), answer: self.equity.q2Answer)
            
        } else if self.measureShortName == "q3" {
            self.getMeasureResultsAndSetLabelText(status: self.equity.q3Status, longName: Constants.measureMetadata.longName(.q3)(), answer: self.equity.q3Answer)
            
        } else if self.measureShortName == "q4" {
            self.getMeasureResultsAndSetLabelText(status: self.equity.q4Status, longName: Constants.measureMetadata.longName(.q4)(), answer: self.equity.q4Answer)
            
        } else if self.measureShortName == "q5" {
            self.getMeasureResultsAndSetLabelText(status: self.equity.q5Status, longName: Constants.measureMetadata.longName(.q5)(), answer: self.equity.q5Answer)
            
        } else {
            self.getMeasureResultsAndSetLabelText(status: self.equity.q6Status, longName: Constants.measureMetadata.longName(.q6)(), answer: self.equity.q6Answer)
        }
    }
}
