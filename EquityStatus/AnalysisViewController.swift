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
        //self.title = "Analysis Required"  // only used in tabBar Controller's didSelect
        self.analysisViewInst.delegate = self
        print("viewDidLoad")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.analysisViewInst.createEquitiesForAnalysis()
        self.analysisViewInst.analysisTableViewInst.reloadData()
        print("viewWillAppear")
    }
    
    override func loadView(){
        // load the view into the view controller
        self.analysisViewInst = AnalysisView(frame: CGRect.zero)
        self.view = self.analysisViewInst
        print("loadView")
    }
    
    func openEquityDetail(_ equity: Equity) {
        let equityDetailViewControllerInst = EquityDetailViewController()
        equityDetailViewControllerInst.equity = equity
        self.title = "" // this value is passed to the back button label in the destination VC
        navigationController?.pushViewController(equityDetailViewControllerInst, animated: false) // show destination with nav bar
    }
}
