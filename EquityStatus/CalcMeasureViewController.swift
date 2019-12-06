//
//  CalcMeasureViewController.swift
//  EquityStatus
//
//  Created by Paul Tangen on 1/27/17.
//  Copyright © 2017 Paul Tangen. All rights reserved.
//

import UIKit

class CalcMeasureViewController: UIViewController, MeasureDetailViewDelegate {

    var calcMeasureViewInst = CalcMeasureView()
    let store = DataStore.sharedInstance
    var measure = String()
    var company: Company!
    var historicalDataLabel: String?
    var chartLabel: String?
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.calcMeasureViewInst.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.calcMeasureViewInst.measure = self.measure
    }
    
    override func loadView(){

        // load the ui view into the view controller
        self.calcMeasureViewInst.frame = CGRect.zero
        self.view = self.calcMeasureViewInst
        
        // setup ui view
        self.calcMeasureViewInst.company = self.company
        print("accessibilityLabel: \(String(describing: self.accessibilityLabel))")
        if let measure = self.accessibilityLabel {
            self.calcMeasureViewInst.setResultsLabelsForMeasure(measure: measure)
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
