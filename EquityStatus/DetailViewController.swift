//
//  DetailViewController.swift
//  EquityStatus
//
//  Created by Paul Tangen on 12/29/16.
//  Copyright © 2016 Paul Tangen. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var detailViewInst: DetailView!
    var equity: Equity!

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.detailViewInst.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        
        self.navigationController?.navigationBar.backItem?.title = "Back"
        self.title = "\(equity.name) (\(self.equity.ticker))"
        
        self.detailViewInst.ROEaResultDesc.text = "Avg Return on Equity: \(self.equity.ROEaResult)%"
        Utilities.setStatusIcon(status: self.equity.ROEaStatus, label: self.detailViewInst.ROEaStatusDesc)
        
        self.detailViewInst.EPSiResultDesc.text = "Earnings Per Share Growth Rate: \(self.equity.EPSiResult)%"
        Utilities.setStatusIcon(status: self.equity.EPSiStatus, label: self.detailViewInst.EPSiStatusDesc)
        
        self.detailViewInst.EPSvResultDesc.text = "Earnings Per Share Volatility: \(self.equity.EPSvResult)"
        Utilities.setStatusIcon(status: self.equity.EPSvStatus, label: self.detailViewInst.EPSvStatusDesc)
        
        self.detailViewInst.BViResultDesc.text = "Book Value Growth Rate: \(self.equity.BViResult)%"
        Utilities.setStatusIcon(status: self.equity.BViStatus, label: self.detailViewInst.BViStatusDesc)
        
        self.detailViewInst.DRaResultDesc.text = "Avg Debt Ratio: \(self.equity.DRaResult)"
        Utilities.setStatusIcon(status: self.equity.DRaStatus, label: self.detailViewInst.DRaStatusDesc)
        
        self.detailViewInst.SOrResultDesc.text = "Shares Outstanding Reduced: \(self.equity.SOrResult)"
        Utilities.setStatusIcon(status: self.equity.SOrStatus, label: self.detailViewInst.SOrStatusDesc)
        
        self.detailViewInst.previousROIResultDesc.text = "Previous Return on Investment: \(self.equity.previousROIResult)"
        Utilities.setStatusIcon(status: self.equity.previousROIStatus, label: self.detailViewInst.previousROIStatusDesc)
        
        self.detailViewInst.expectedROIResultDesc.text = "Expected Return on Investment: \(self.equity.expectedROIResult)"
        Utilities.setStatusIcon(status: self.equity.expectedROIStatus, label: self.detailViewInst.expectedROIStatusDesc)
        
        self.detailViewInst.q1Desc.text = "Is there a strong upward trend in the EPS?"
        Utilities.setStatusIcon(status: self.equity.q1Status, label: self.detailViewInst.q1StatusDesc)
        
        self.detailViewInst.q2Desc.text = "Do you understand the product/service?"
        Utilities.setStatusIcon(status: self.equity.q2Status, label: self.detailViewInst.q2StatusDesc)
        
        self.detailViewInst.q3Desc.text = "Has the product/service been consistent for 10 years?"
        Utilities.setStatusIcon(status: self.equity.q3Status, label: self.detailViewInst.q3StatusDesc)
        
        self.detailViewInst.q4Desc.text = "Does the company invest in it's area of expertise?"
        Utilities.setStatusIcon(status: self.equity.q4Status, label: self.detailViewInst.q4StatusDesc)
        
        self.detailViewInst.q5Desc.text = "Are few expenditures required to maintain operations?"
        Utilities.setStatusIcon(status: self.equity.q5Status, label: self.detailViewInst.q5StatusDesc)
        
        self.detailViewInst.q6Desc.text = "Is the company free to adjust prices with inflation?"
        Utilities.setStatusIcon(status: self.equity.q6Status, label: self.detailViewInst.q6StatusDesc)
    }

    override func loadView(){
        // hide nav bar on login page
        self.navigationController?.setNavigationBarHidden(true, animated: .init(true))
        
        // load the view into the view controller
        self.detailViewInst = DetailView(frame: CGRect.zero)
        self.detailViewInst.equity = self.equity
        self.view = self.detailViewInst
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
