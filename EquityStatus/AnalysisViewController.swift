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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func loadView(){
        // load the view into the view controller
        self.analysisViewInst = AnalysisView(frame: CGRect.zero)
        self.view = self.analysisViewInst
    }
    
    func openDetail(_ equity: Equity) {
        let detailViewControllerInst = DetailViewController()
        detailViewControllerInst.equity = equity
        navigationController?.pushViewController(detailViewControllerInst, animated: false) // show destination with nav bar
    }
}
