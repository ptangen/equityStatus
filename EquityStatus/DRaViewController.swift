//
//  DRaViewController.swift
//  EquityStatus
//
//  Created by Paul Tangen on 1/27/17.
//  Copyright © 2017 Paul Tangen. All rights reserved.
//

import UIKit

class DRaViewController: UIViewController, MeasureDetailViewDelegate {
    
    var DraViewInst = CalcMeasureView()
    let store = DataStore.sharedInstance
    var measureTicker = String()
    var equity: Equity!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.DraViewInst.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.DraViewInst.measureTicker = self.measureTicker
    }
    
    override func loadView(){
        
        let ticker = Utilities.getTickerFromLabel(fullString: measureTicker)
        self.equity = self.store.getEquityByTickerFromStore(ticker: ticker)
        
        // load the ui view into the view controller
        self.DraViewInst = CalcMeasureView(frame: CGRect.zero)
        self.view = self.DraViewInst
        
        // setup ui view
        self.DraViewInst.equity = self.equity
        self.DraViewInst.setResultsLabelsForMeasure(fullString: measureTicker)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAlertMessage(_ message: String) {
        Utilities.showAlertMessage(message, viewControllerInst: self)
    }
}
