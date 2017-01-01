//
//  MeasureDetailViewController.swift
//  EquityStatus
//
//  Created by Paul Tangen on 12/30/16.
//  Copyright © 2016 Paul Tangen. All rights reserved.
//

import UIKit

class MeasureDetailViewController: UIViewController {
    
    var measureDetailViewInst: MeasureDetailView!
    let store = DataStore.sharedInstance
    var measureTicker: String = String()
    var equity: Equity!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.title = "\(equity.name) (\(equity.ticker))"
    }
    
    override func loadView(){
        
        let ticker = Utilities.getTickerFromLabel(fullString: measureTicker)
        self.equity = self.store.getEquityByTickerFromStore(ticker: ticker)
        
        // load the ui view into the view controller
        self.measureDetailViewInst = MeasureDetailView(frame: CGRect.zero)
        self.measureDetailViewInst.measureTicker = self.measureTicker
        self.view = self.measureDetailViewInst
        
        // setup ui view
        self.measureDetailViewInst.equity = self.equity
        self.measureDetailViewInst.setResultsLabelsForMeasure(fullString: measureTicker)
    }
}