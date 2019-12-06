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
    //var equity: Equity!
    var company: Company!
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
        self.qStatusPicker.setTitleTextAttributes([ NSAttributedString.Key.font: UIFont(name: Constants.iconFont.fontAwesome.rawValue, size: Constants.iconSize.small.rawValue)! ], for: .normal)
        
        let segmentButtonWidth = UIScreen.main.bounds.width / 4
        self.qStatusPicker.setWidth(segmentButtonWidth, forSegmentAt: 0)
        self.qStatusPicker.setWidth(segmentButtonWidth, forSegmentAt: 1)
        self.qStatusPicker.setWidth(segmentButtonWidth, forSegmentAt: 2)
        self.qStatusPicker.tintColor = UIColor(named: .blue)
        
        self.qStatusPicker.addTarget(self, action: #selector(self.statusValueChanged(_:)), for: .valueChanged)
        self.qAnswerView.delegate = self
    }
    
    @objc func statusValueChanged(_ sender:UISegmentedControl!) {
        
        self.qAnswerView.resignFirstResponder()
        
        switch sender.selectedSegmentIndex {
        case 1:
            self.updateQStatus(passed: true)
        case 2:
            self.updateQStatus(passed: false)
        default:
            self.updateQStatus(passed: false) // TODO handle nil  // user can only set values for subjective measures so undefined is valid response
        }
    }
    
    func updateQStatus(passed: Bool) {
        
        APIClient.setSubjectiveStatus(question: self.measureShortName, status: passed, company: self.company, completion: { response in
            
            switch response {
            case .ok:
                Utilities.getStatusIcon(status: passed, uiLabel: self.statusIcon)
                self.statusValueDesc.text = "(" + self.getStatusDesc(passed: passed) + ")"
                
                // udpate the status in the equity
                switch self.measureShortName {
                case "q1":
                    self.company.q1_passed = false // status
                case "q2":
                    self.company.q2_passed = false // status
                case "q3":
                    self.company.q3_passed = false // status
                case "q4":
                    self.company.q4_passed = false // status
                case "q5":
                    self.company.q5_passed = false // status
                case "q6":
                    self.company.q6_passed = false // status
                default:
                    break
                }
                
            case.failed, .noReply:
                self.delegate?.showAlertMessage("The server was unable to save this status change. Please forward this message to ptangen@ptangen.com")
                break;
                
            default:
                break;
            }
            //self.store.resetTabValue(equity: self.equity)
        })
    }
    
    func updateQAnswer(answer: String) {
        
        APIClient.setSubjectiveAnswer(question: self.measureShortName, answer: answer, company: self.company, completion: { response in
            
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
    
    func getStatusDesc(passed: Bool?) -> String {
        if let passedUnwrapped = passed {
            return passedUnwrapped.description
        } else {
            return "no data"
        }
    }
    
    func showSubjectiveMeasureControls(qStatus: Bool) {
        // show
        self.qStatusPicker.isHidden = false
        self.qAnswerView.isHidden = false
        
        // set status on button bar
        switch qStatus {
        case true:
            self.qStatusPicker.selectedSegmentIndex = 1
        case false:
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
    
    func getMeasureResultsAndSetLabelText(passed: Bool, longName: String, answer: String?) {
        self.showSubjectiveMeasureControls(qStatus: passed)
        self.measureLongNameLabel.text = longName
        Utilities.getStatusIcon(status: passed, uiLabel: self.statusIcon)
        self.statusValueDesc.text = "(" + getStatusDesc(passed: passed) + ")"
        if let answerUnwrapped = answer {
            self.setTextInQAnswerView(textToDisplay: answerUnwrapped)
        }
    }
    
    func setResultsLabelsForMeasure(fullString: String) {
        
        self.statusLabel.text = "Status:"
        
        // extract the measure name
        let chars = fullString;
        if let indexLeftParen = chars.firstIndex(of: "(") {
            _ = chars.index(before: indexLeftParen)
            // 4.2 error: self.measureShortName = fullString[chars.startIndex...indexBeforeLeftParen]
            self.measureShortName = fullString
        }
        print("self.measureShortName: \(self.measureShortName)")
        let measureInfo = self.store.measureInfo[fullString]!
        
        // get the measure results and set the label text
        if self.measureShortName == "q1" {
            if let q1_passed = self.company.q1_passed {
                self.getMeasureResultsAndSetLabelText(passed: q1_passed, longName: measureInfo["longName"]!, answer: self.company.q1_answer)
            }
            
        } else if self.measureShortName == "q2" {
            if let q2_passed = self.company.q2_passed {
                self.getMeasureResultsAndSetLabelText(passed: q2_passed, longName: measureInfo["longName"]!, answer: self.company.q2_answer)
            }
            
        } else if self.measureShortName == "q3" {
            if let q3_passed = self.company.q3_passed {
            self.getMeasureResultsAndSetLabelText(passed: q3_passed, longName: measureInfo["longName"]!, answer: self.company.q3_answer)
            }
            
        } else if self.measureShortName == "q4" {
            if let q4_passed = self.company.q4_passed {
                self.getMeasureResultsAndSetLabelText(passed: q4_passed, longName: measureInfo["longName"]!, answer: self.company.q4_answer)
            }
            
        } else if self.measureShortName == "q5" {
            if let q5_passed = self.company.q5_passed {
                self.getMeasureResultsAndSetLabelText(passed: q5_passed, longName: measureInfo["longName"]! + "XX", answer: self.company.q5_answer)
            }
            
        } else if self.measureShortName == "q6" {
            if let q6_passed = self.company.q6_passed {
                self.getMeasureResultsAndSetLabelText(passed: q6_passed, longName: measureInfo["longName"]!, answer: self.company.q6_answer)
            }
        }
    }
}
