//
//  AnalysisViewController.swift
//  EquityStatus
//
//  Created by Paul Tangen on 12/19/16.
//  Copyright © 2016 Paul Tangen. All rights reserved.
//

import UIKit

class AnalysisViewController: UIViewController {
    
    var analysisViewInst: AnalysisView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Analysis Required"
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

}
