//
//  BViViewController.swift
//  EquityStatus
//
//  Created by Paul Tangen on 1/27/17.
//  Copyright © 2017 Paul Tangen. All rights reserved.
//

import UIKit

class BViViewController: UIViewController, MeasureDetailViewDelegate {
    
    var BViViewInst = CalcMeasureView()
    let store = DataStore.sharedInstance
    var measureTicker = String()
    var equity: Equity!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.BViViewInst.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.BViViewInst.measureTicker = self.measureTicker
        self.BViViewInst.fetchChartData(historicalDataLabel: Constants.measureMetadata.historicalDataLabel(.BVi)())
    }
    
    override func loadView(){
        
        let ticker = Utilities.getTickerFromLabel(fullString: measureTicker)
        self.equity = self.store.getEquityByTickerFromStore(ticker: ticker)
        
        // load the ui view into the view controller
        self.BViViewInst = CalcMeasureView(frame: CGRect.zero)
        self.view = self.BViViewInst
        
        // setup ui view
        self.BViViewInst.equity = self.equity
        self.BViViewInst.setResultsLabelsForMeasure(fullString: measureTicker)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAlertMessage(_ message: String) {
        Utilities.showAlertMessage(message, viewControllerInst: self)
    }
}
