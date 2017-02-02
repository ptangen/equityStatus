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
    var measureTicker = String()
    var equity: Equity!
    var historicalDataLabel: String?
    var chartLabel: String?
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.calcMeasureViewInst.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.calcMeasureViewInst.measureTicker = self.measureTicker
        
        // if the view has a chart, pass the historicalDataLabel and chartLabel
        if let historicalDataLabel = self.historicalDataLabel, let chartLabel = self.chartLabel {
            self.calcMeasureViewInst.fetchChartData(historicalDataLabel: historicalDataLabel)
            self.calcMeasureViewInst.chartLabel.text = chartLabel
        } else {
            self.calcMeasureViewInst.barChartView.isHidden = true
            self.calcMeasureViewInst.chartLabel.isHidden = true
        }
    }
    
    override func loadView(){
        
        let ticker = Utilities.getTickerFromLabel(fullString: measureTicker)
        self.equity = self.store.getEquityByTickerFromStore(ticker: ticker)

        // load the ui view into the view controller
        self.calcMeasureViewInst.frame = CGRect.zero
        self.view = self.calcMeasureViewInst
        
        // setup ui view
        self.calcMeasureViewInst.equity = self.equity
        self.calcMeasureViewInst.setResultsLabelsForMeasure(fullString: measureTicker)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAlertMessage(_ message: String) {
        Utilities.showAlertMessage(message, viewControllerInst: self)
    }

}