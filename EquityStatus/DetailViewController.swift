//
//  DetailViewController.swift
//  EquityStatus
//
//  Created by Paul Tangen on 12/29/16.
//  Copyright © 2016 Paul Tangen. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, DetailViewDelegate {
    
    var detailViewInst: DetailView!
    var equity: Equity!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.detailViewInst.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.popualateLabels()
    }

    override func loadView(){
        // hide nav bar on login page
        self.navigationController?.setNavigationBarHidden(true, animated: .init(true))
        
        // load the view into the view controller
        self.detailViewInst = DetailView(frame: CGRect.zero)
        self.detailViewInst.equity = self.equity
        self.view = self.detailViewInst
        self.navigationController?.navigationBar.backItem?.title = "Back"
        self.title = "\(equity.name) (\(self.equity.ticker))"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func openSingleDetail(_ source: String) {
        let singleDetailViewControllerInst = SingleDetailViewController()
        singleDetailViewControllerInst.source = source
        navigationController?.pushViewController(singleDetailViewControllerInst, animated: false) // show destination with nav bar
    }
    
    func popualateLabels() {
        
        // ROEaResult label
        if self.equity.ROEaResult == -1000 {
            self.detailViewInst.ROEaResultDesc.text = "Avg Return on Equity: no data"
        } else {
            self.detailViewInst.ROEaResultDesc.text = "Avg Return on Equity: \(self.equity.ROEaResult)%"
        }
        self.detailViewInst.ROEaResultDescTap.accessibilityLabel = "ROEa(\(equity.ticker))"
        Utilities.setStatusIcon(status: self.equity.ROEaStatus, label: self.detailViewInst.ROEaStatusDesc)
        
        // EPSiResult label
        if self.equity.EPSiResult == -1000 {
            self.detailViewInst.EPSiResultDesc.text = "Earnings Per Share Growth Rate: no data"
        } else {
            self.detailViewInst.EPSiResultDesc.text = "Earnings Per Share Growth Rate: \(self.equity.EPSiResult)%"
        }
        self.detailViewInst.EPSiResultDescTap.accessibilityLabel = "EPSi(\(equity.ticker))"
        Utilities.setStatusIcon(status: self.equity.EPSiStatus, label: self.detailViewInst.EPSiStatusDesc)
        
        // EPSvResult label
        if self.equity.EPSvResult == -1000 {
            self.detailViewInst.EPSvResultDesc.text = "Earnings Per Share Volatility: no data"
        } else {
            self.detailViewInst.EPSvResultDesc.text = "Earnings Per Share Volatility: \(self.equity.EPSvResult)"
        }
        self.detailViewInst.EPSvResultDescTap.accessibilityLabel = "EPSv(\(equity.ticker))"
        Utilities.setStatusIcon(status: self.equity.EPSvStatus, label: self.detailViewInst.EPSvStatusDesc)
        
        // BViResult label
        if self.equity.BViResult == -1000 {
            self.detailViewInst.BViResultDesc.text = "Book Value Growth Rate: no data"
        } else {
            self.detailViewInst.BViResultDesc.text = "Book Value Growth Rate: \(self.equity.BViResult)%"
        }
        self.detailViewInst.BViResultDescTap.accessibilityLabel = "BVi(\(equity.ticker))"
        Utilities.setStatusIcon(status: self.equity.BViStatus, label: self.detailViewInst.BViStatusDesc)
        
        // DRaResult label
        if self.equity.DRaResult == -1000 {
            self.detailViewInst.DRaResultDesc.text = "Avg Debt Ratio: no data"
        } else {
            self.detailViewInst.DRaResultDesc.text = "Avg Debt Ratio: \(self.equity.DRaResult)"
        }
        self.detailViewInst.DRaResultDescTap.accessibilityLabel = "DRa(\(equity.ticker))"
        Utilities.setStatusIcon(status: self.equity.DRaStatus, label: self.detailViewInst.DRaStatusDesc)
        
        // SOrResult label
        if self.equity.SOrResult == -1000 {
            self.detailViewInst.SOrResultDesc.text = "Shares Outstanding Reduced: no data"
        } else {
            self.detailViewInst.SOrResultDesc.text = "Shares Outstanding Reduced: \(self.equity.SOrResult)"
        }
        self.detailViewInst.SOrResultDescTap.accessibilityLabel = "SOr(\(equity.ticker))"
        Utilities.setStatusIcon(status: self.equity.SOrStatus, label: self.detailViewInst.SOrStatusDesc)
        
        // previousROIResult label
        if self.equity.previousROIResult == -1000 {
            self.detailViewInst.previousROIResultDesc.text = "Previous Return on Investment: no data"
        } else {
            self.detailViewInst.previousROIResultDesc.text = "Previous Return on Investment: \(self.equity.previousROIResult)"
        }
        self.detailViewInst.previousROIResultDescTap.accessibilityLabel = "previousROI(\(equity.ticker))"
        Utilities.setStatusIcon(status: self.equity.previousROIStatus, label: self.detailViewInst.previousROIStatusDesc)
        
        // expectedROIResult label
        if self.equity.expectedROIResult == -1000 {
            self.detailViewInst.expectedROIResultDesc.text = "Expected Return on Investment: no data"
        } else {
            self.detailViewInst.expectedROIResultDesc.text = "Expected Return on Investment: \(self.equity.expectedROIResult)"
        }
        self.detailViewInst.expectedROIResultDescTap.accessibilityLabel = "expectedROI(\(equity.ticker))"
        Utilities.setStatusIcon(status: self.equity.expectedROIStatus, label: self.detailViewInst.expectedROIStatusDesc)
        
        // q1 label
        self.detailViewInst.q1Desc.text = "Is there a strong upward trend in the EPS?"
        self.detailViewInst.q1DescTap.accessibilityLabel = "q1(\(equity.ticker))"
        Utilities.setStatusIcon(status: self.equity.q1Status, label: self.detailViewInst.q1StatusDesc)
        
        // q2 label
        self.detailViewInst.q2Desc.text = "Do you understand the product/service?"
        self.detailViewInst.q2DescTap.accessibilityLabel = "q2(\(equity.ticker))"
        Utilities.setStatusIcon(status: self.equity.q2Status, label: self.detailViewInst.q2StatusDesc)
        
        // q3 label
        self.detailViewInst.q3Desc.text = "Has the product/service been consistent for 10 years?"
        self.detailViewInst.q3DescTap.accessibilityLabel = "q3(\(equity.ticker))"
        Utilities.setStatusIcon(status: self.equity.q3Status, label: self.detailViewInst.q3StatusDesc)
        
        // q4 label
        self.detailViewInst.q4Desc.text = "Does the company invest in it's area of expertise?"
        self.detailViewInst.q4DescTap.accessibilityLabel = "q4(\(equity.ticker))"
        Utilities.setStatusIcon(status: self.equity.q4Status, label: self.detailViewInst.q4StatusDesc)
        
        // q5 label
        self.detailViewInst.q5Desc.text = "Are few expenditures required to maintain operations?"
        self.detailViewInst.q5DescTap.accessibilityLabel = "q5(\(equity.ticker))"
        Utilities.setStatusIcon(status: self.equity.q5Status, label: self.detailViewInst.q5StatusDesc)
        
        // q6 label
        self.detailViewInst.q6Desc.text = "Is the company free to adjust prices with inflation?"
        self.detailViewInst.q6DescTap.accessibilityLabel = "q6(\(equity.ticker))"
        Utilities.setStatusIcon(status: self.equity.q6Status, label: self.detailViewInst.q6StatusDesc)
    }
}
