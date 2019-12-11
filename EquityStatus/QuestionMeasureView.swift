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
    var company: Company!
    var measure = String()
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
        
        // where clause
//        let selectedTickerQuestion = self.companiesTable.filter(self.tickerCol == ticker)
//        do {
//          try database.run(sselectedTickerQuestion.update(self.previous_roiCol <- Int(measureValue)))
//        } catch {
//            print(error)
//        }
        
//        APIClient.setSubjectiveStatus(question: self.measureShortName, status: passed, company: self.company, completion: { response in
//
//            switch response {
//            case .ok:
//                Utilities.getStatusIcon(status: passed, uiLabel: self.statusIcon)
//                self.statusValueDesc.text = "(" + self.getStatusDesc(passed: passed) + ")"
//
//                // udpate the status in the equity
//                switch self.measureShortName {
//                case "q1":
//                    self.company.q1_passed = false // status
//                case "q2":
//                    self.company.q2_passed = false // status
//                case "q3":
//                    self.company.q3_passed = false // status
//                case "q4":
//                    self.company.q4_passed = false // status
//                case "q5":
//                    self.company.q5_passed = false // status
//                case "q6":
//                    self.company.q6_passed = false // status
//                default:
//                    break
//                }
//
//            case.failed, .noReply:
//                self.delegate?.showAlertMessage("The server was unable to save this status change. Please forward this message to ptangen@ptangen.com")
//                break;
//
//            default:
//                break;
//            }
            //self.store.resetTabValue(equity: self.equity)
 //       })
    }
    
    func updateQAnswer(answer: String) {
        
//        APIClient.setSubjectiveAnswer(question: self.measureShortName, answer: answer, company: self.company, completion: { response in
//            
//            switch response {
//            case .ok:
//                break;
//                
//            case.failed, .noReply:
//                self.delegate?.showAlertMessage("The server was unable to save this status change. Please forward this message to ptangen@ptangen.com")
//                break;
//                
//            default:
//                break;
//            }
//        })
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
    
    func getMeasureResultsAndSetLabelText(passed: Bool?, longName: String, answer: String?) {
        
        if let passedUnwrapped = passed {
            if passedUnwrapped {
                self.qStatusPicker.selectedSegmentIndex = 1
            } else {
                self.qStatusPicker.selectedSegmentIndex = 2
            }
        } else {
            self.qStatusPicker.selectedSegmentIndex = 0
        }
        
        self.measureLongNameLabel.text = longName
        Utilities.getStatusIcon(status: passed, uiLabel: self.statusIcon)
        if let answerUnwrapped = answer {
            self.setTextInQAnswerView(textToDisplay: answerUnwrapped)
        }
    }
    
    func setResultsLabelsForMeasure(measure: String) {
        
        self.statusLabel.text = "Status:"
        let measureInfo = self.store.measureInfo[measure]!
        
        let questions_passed:[String: Bool?] = [
            "q1" : self.company.q1_passed,
            "q2" : self.company.q2_passed,
            "q3" : self.company.q3_passed,
            "q4" : self.company.q4_passed,
            "q5" : self.company.q5_passed,
            "q6" : self.company.q6_passed
        ]
        
        let questions_answer:[String: String?] = [
            "q1" : self.company.q1_answer,
            "q2" : self.company.q2_answer,
            "q3" : self.company.q3_answer,
            "q4" : self.company.q4_answer,
            "q5" : self.company.q5_answer,
            "q6" : self.company.q6_answer
        ]
        
        self.getMeasureResultsAndSetLabelText(
            passed: questions_passed[measure]!, longName: measureInfo["longName"]!, answer: questions_answer[measure]!
        )
    }
}
