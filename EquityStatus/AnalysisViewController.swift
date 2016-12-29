//
//  AnalysisViewController.swift
//  EquityStatus
//
//  Created by Paul Tangen on 12/19/16.
//  Copyright © 2016 Paul Tangen. All rights reserved.
//

import UIKit

class AnalysisViewController: UIViewController, AnalysisViewDelegate {
    
    var analysisViewInst: AnalysisView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Analysis Required"
        self.analysisViewInst.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func loadView(){
        // hide nav bar on login page
        self.navigationController?.isNavigationBarHidden = false
        self.title = "Equity Status - Analysis"
        self.navigationItem.hidesBackButton = true
        
        // load the view into the view controller
        self.analysisViewInst = AnalysisView(frame: CGRect.zero)
        self.view = self.analysisViewInst
    }
    
    func openDetail(_ equity: Equity) {
        print("openDetail in Analysis View Controller")
        let detailViewControllerInst = DetailViewController()
        detailViewControllerInst.equity = equity
        navigationController?.pushViewController(detailViewControllerInst, animated: false) // show destination with nav bar
    }

}
