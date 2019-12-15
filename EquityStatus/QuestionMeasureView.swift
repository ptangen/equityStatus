//
//  QuestionMeasureView.swift
//  EquityStatus
//
//  Created by Paul Tangen on 1/27/17.
//  Copyright © 2017 Paul Tangen. All rights reserved.
//

import UIKit
import SQLite

class QuestionMeasureView: UIView, UITextViewDelegate {

    weak var delegate: MeasureDetailViewDelegate?
    let store = DataStore.sharedInstance
    var company: Company!
    var measure = String()
    var measureLongNameLabel = UILabel()
    var statusLabel = UILabel()
    var statusIcon = UILabel()
    var statusValueDesc = UILabel()
    var qStatusPicker = UISegmentedControl()
    var qAnswerView = UITextView()
    var qAnswerViewDidChange = false
    
    let companiesTable =    Table("companiesTable")
    let tickerCol =         Expression<String>("tickerCol")
    
    let q1_answerCol =   Expression<String?>("q1_answerCol")
    let q2_answerCol =   Expression<String?>("q2_answerCol")
    let q3_answerCol =   Expression<String?>("q3_answerCol")
    let q4_answerCol =   Expression<String?>("q4_answerCol")
    let q5_answerCol =   Expression<String?>("q5_answerCol")
    let q6_answerCol =   Expression<String?>("q6_answerCol")
    
    let q1_passedCol =   Expression<Bool?>("q1_passedCol")
    let q2_passedCol =   Expression<Bool?>("q2_passedCol")
    let q3_passedCol =   Expression<Bool?>("q3_passedCol")
    let q4_passedCol =   Expression<Bool?>("q4_passedCol")
    let q5_passedCol =   Expression<Bool?>("q5_passedCol")
    let q6_passedCol =   Expression<Bool?>("q6_passedCol")
    
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
            self.updateQStatus(passedOptional: true)
        case 2:
            self.updateQStatus(passedOptional: false)
        default:
            self.updateQStatus(passedOptional: nil)
        }
    }
    
    func updateQStatus(passedOptional: Bool?) {
        
        let database = DBUtilities.getDBConnection()
        let selectedTickerQuestion = self.companiesTable.filter(self.tickerCol == self.company.ticker)
    
        do {
            //get the column to update and submit the query
            try database.run(selectedTickerQuestion.update(getMeasurePassedColumn(measure: measure) <- passedOptional))
            // update the object property TODO: use setter
            self.setMeasurePassedObjectProperty(measure: measure, passed: passedOptional)
            Utilities.getStatusIcon(status: passedOptional, uiLabel: self.statusIcon)
        } catch {
            print(error)
        }
    }
    
    func updateQAnswer(answer: String) {
        
        let database = DBUtilities.getDBConnection()
        let selectedTickerQuestion = self.companiesTable.filter(self.tickerCol == self.company.ticker)
        
        do {
            //get the column to update and submit the query
            try database.run(selectedTickerQuestion.update(getMeasureAnswerColumn(measure: measure) <- answer))
            // update the object property TODO: use setter
            self.setMeasureAnswerObjectProperty(measure: measure, answer: answer)
        } catch {
            print(error)
        }
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
    
    func getMeasurePassedColumn(measure: String) -> Expression<Bool?> {
        // get column to update
        switch measure {
        case "q1":
            return self.q1_passedCol
        case "q2":
            return self.q2_passedCol
        case "q3":
            return self.q3_passedCol
        case "q4":
            return self.q4_passedCol
        case "q5":
            return self.q5_passedCol
        case "q6":
            return self.q6_passedCol
        default:
            return Expression<Bool?>("")
        }
    }
    
    func getMeasureAnswerColumn(measure: String) -> Expression<String?> {
        // get column to update
        switch measure {
        case "q1":
            return self.q1_answerCol
        case "q2":
            return self.q2_answerCol
        case "q3":
            return self.q3_answerCol
        case "q4":
            return self.q4_answerCol
        case "q5":
            return self.q5_answerCol
        case "q6":
            return self.q6_answerCol
        default:
            return Expression<String?>("")
        }
    }
    
    func setMeasurePassedObjectProperty(measure: String, passed: Bool?) {
        // update object value
        switch measure {
        case "q1":
            self.company.q1_passed = passed
        case "q2":
            self.company.q2_passed = passed
        case "q3":
            self.company.q3_passed = passed
        case "q4":
            self.company.q4_passed = passed
        case "q5":
            self.company.q5_passed = passed
        case "q6":
            self.company.q6_passed = passed
        default:
            break
        }
    }
    
    func setMeasureAnswerObjectProperty(measure: String, answer: String?) {
        // update object value
        switch measure {
        case "q1":
            self.company.q1_answer = answer
        case "q2":
            self.company.q2_answer = answer
        case "q3":
            self.company.q3_answer = answer
        case "q4":
            self.company.q4_answer = answer
        case "q5":
            self.company.q5_answer = answer
        case "q6":
            self.company.q6_answer = answer
        default:
            break
        }
    }
}
