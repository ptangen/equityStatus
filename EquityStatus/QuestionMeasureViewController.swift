//
//  QuestionMeasureViewController.swift
//  EquityStatus
//
//  Created by Paul Tangen on 1/27/17.
//  Copyright © 2017 Paul Tangen. All rights reserved.
//

import UIKit

class QuestionMeasureViewController: UIViewController, MeasureDetailViewDelegate {

    var questionMeasureViewInst = QuestionMeasureView()
    let store = DataStore.sharedInstance
    var measure = String()
    var company: Company!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.questionMeasureViewInst.delegate = self
        // back button accessibility label
        self.navigationItem.backBarButtonItem?.accessibilityLabel = "backButton"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.questionMeasureViewInst.measure = self.measure
    }
    
    override func loadView(){
        
        // load the ui view into the view controller
        self.questionMeasureViewInst.frame = CGRect.zero
        self.view = self.questionMeasureViewInst
        
        // setup ui view
        self.questionMeasureViewInst.company = self.company
        if let measure = self.accessibilityLabel {
            print("measure from self.accessibilityLabel: \(measure)")
            self.questionMeasureViewInst.setResultsLabelsForMeasure(measure: measure)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAlertMessage(_ message: String) {
        Utilities.showAlertMessage(message, viewControllerInst: self)
    }
}
