//
//  EquityDetailViewController.swift
//  EquityStatus
//
//  Created by Paul Tangen on 12/29/16.
//  Copyright © 2016 Paul Tangen. All rights reserved.
//

import UIKit

class EquityDetailViewController: UIViewController, EquityDetailViewDelegate {
    
    var equityDetailViewInst = EquityDetailView()
    var equity: Equity!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.equityDetailViewInst.delegate = self
        self.navigationItem.backBarButtonItem?.accessibilityLabel = "backButton"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.backItem?.title = ""
        self.popualateLabels()
        self.title = "\(equity.name.capitalized) (\(self.equity.ticker))"
    }

    override func loadView(){
        self.equityDetailViewInst.frame = CGRect.zero
        self.equityDetailViewInst.equity = self.equity
        self.view = self.equityDetailViewInst
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func openMeasureDetail(_ measureTicker: String) {
        let measurePageViewControllerInst = MeasurePageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        measurePageViewControllerInst.measureTicker = measureTicker
        self.title = "" // this value is passed to the back button label in the destination VC
        navigationController?.pushViewController(measurePageViewControllerInst, animated: true) // show destination with nav bar
    }
    
    func popualateLabels() {
        
        // ROEaResult label
        if self.equity.ROEaResult == -1000 {
            self.equityDetailViewInst.ROEaResultDesc.text = "\(Constants.measureMetadata.longName(.ROEa)()): no data"
        } else {
            self.equityDetailViewInst.ROEaResultDesc.text = "\(Constants.measureMetadata.longName(.ROEa)()): \(self.equity.ROEaResult)%"
        }
        self.equityDetailViewInst.ROEaResultDescTap.accessibilityLabel = "ROEa(\(equity.ticker))"
        Utilities.setStatusIcon(status: self.equity.ROEaStatus, uiLabel: self.equityDetailViewInst.ROEaStatusDesc)
        
        // EPSiResult label
        if self.equity.EPSiResult == -1000 {
            self.equityDetailViewInst.EPSiResultDesc.text = "\(Constants.measureMetadata.longName(.EPSi)()): no data"
        } else {
            self.equityDetailViewInst.EPSiResultDesc.text = "\(Constants.measureMetadata.longName(.EPSi)()): \(self.equity.EPSiResult)%"
        }
        self.equityDetailViewInst.EPSiResultDescTap.accessibilityLabel = "EPSi(\(equity.ticker))"
        Utilities.setStatusIcon(status: self.equity.EPSiStatus, uiLabel: self.equityDetailViewInst.EPSiStatusDesc)
        
        // EPSvResult label
        if self.equity.EPSvResult == -1000 {
            self.equityDetailViewInst.EPSvResultDesc.text = "\(Constants.measureMetadata.longName(.EPSv)()): no data"
        } else {
            self.equityDetailViewInst.EPSvResultDesc.text = "\(Constants.measureMetadata.longName(.EPSv)()): \(self.equity.EPSvResult)"
        }
        self.equityDetailViewInst.EPSvResultDescTap.accessibilityLabel = "EPSv(\(equity.ticker))"
        Utilities.setStatusIcon(status: self.equity.EPSvStatus, uiLabel: self.equityDetailViewInst.EPSvStatusDesc)
        
        // BViResult label
        if self.equity.BViResult == -1000 {
            self.equityDetailViewInst.BViResultDesc.text = "\(Constants.measureMetadata.longName(.BVi)()): no data"
        } else {
            self.equityDetailViewInst.BViResultDesc.text = "\(Constants.measureMetadata.longName(.BVi)()): \(self.equity.BViResult)%"
        }
        self.equityDetailViewInst.BViResultDescTap.accessibilityLabel = "BVi(\(equity.ticker))"
        Utilities.setStatusIcon(status: self.equity.BViStatus, uiLabel: self.equityDetailViewInst.BViStatusDesc)
        
        // DRaResult label
        if self.equity.DRaResult == -1000 {
            self.equityDetailViewInst.DRaResultDesc.text = "\(Constants.measureMetadata.longName(.DRa)()): no data"
        } else {
            self.equityDetailViewInst.DRaResultDesc.text = "\(Constants.measureMetadata.longName(.DRa)()): \(self.equity.DRaResult)"
        }
        self.equityDetailViewInst.DRaResultDescTap.accessibilityLabel = "DRa(\(equity.ticker))"
        Utilities.setStatusIcon(status: self.equity.DRaStatus, uiLabel: self.equityDetailViewInst.DRaStatusDesc)
        
        // SOrResult label
        if self.equity.SOrResult == -1000 {
            self.equityDetailViewInst.SOrResultDesc.text = "\(Constants.measureMetadata.longName(.SOr)()): no data"
        } else {
            self.equityDetailViewInst.SOrResultDesc.text = "\(Constants.measureMetadata.longName(.SOr)()): \(self.equity.SOrResult)"
        }
        self.equityDetailViewInst.SOrResultDescTap.accessibilityLabel = "SOr(\(equity.ticker))"
        Utilities.setStatusIcon(status: self.equity.SOrStatus, uiLabel: self.equityDetailViewInst.SOrStatusDesc)
        
        // previousROIResult label
        if self.equity.previousROIResult == -1000 {
            self.equityDetailViewInst.previousROIResultDesc.text = "\(Constants.measureMetadata.longName(.previousROI)()): no data"
        } else {
            self.equityDetailViewInst.previousROIResultDesc.text = "\(Constants.measureMetadata.longName(.previousROI)()): \(self.equity.previousROIResult)%"
        }
        self.equityDetailViewInst.previousROIResultDescTap.accessibilityLabel = "previousROI(\(equity.ticker))"
        Utilities.setStatusIcon(status: self.equity.previousROIStatus, uiLabel: self.equityDetailViewInst.previousROIStatusDesc)
        
        // expectedROIResult label
        if self.equity.expectedROIResult == -1000 {
            self.equityDetailViewInst.expectedROIResultDesc.text = "\(Constants.measureMetadata.longName(.expectedROI)()): no data"
        } else {
            self.equityDetailViewInst.expectedROIResultDesc.text = "\(Constants.measureMetadata.longName(.expectedROI)()): \(self.equity.expectedROIResult)%"
        }
        self.equityDetailViewInst.expectedROIResultDescTap.accessibilityLabel = "expectedROI(\(equity.ticker))"
        Utilities.setStatusIcon(status: self.equity.expectedROIStatus, uiLabel: self.equityDetailViewInst.expectedROIStatusDesc)
        
        // q1 label
        self.equityDetailViewInst.q1Desc.text = Constants.measureMetadata.longName(.q1)()
        self.equityDetailViewInst.q1DescTap.accessibilityLabel = "q1(\(equity.ticker))"
        Utilities.setStatusIcon(status: self.equity.q1Status, uiLabel: self.equityDetailViewInst.q1StatusDesc)
        
        // q2 label
        self.equityDetailViewInst.q2Desc.text = Constants.measureMetadata.longName(.q2)()
        self.equityDetailViewInst.q2DescTap.accessibilityLabel = "q2(\(equity.ticker))"
        Utilities.setStatusIcon(status: self.equity.q2Status, uiLabel: self.equityDetailViewInst.q2StatusDesc)
        
        // q3 label
        self.equityDetailViewInst.q3Desc.text = Constants.measureMetadata.longName(.q3)()
        self.equityDetailViewInst.q3DescTap.accessibilityLabel = "q3(\(equity.ticker))"
        Utilities.setStatusIcon(status: self.equity.q3Status, uiLabel: self.equityDetailViewInst.q3StatusDesc)
        
        // q4 label
        self.equityDetailViewInst.q4Desc.text = Constants.measureMetadata.longName(.q4)()
        self.equityDetailViewInst.q4DescTap.accessibilityLabel = "q4(\(equity.ticker))"
        Utilities.setStatusIcon(status: self.equity.q4Status, uiLabel: self.equityDetailViewInst.q4StatusDesc)
        
        // q5 label
        self.equityDetailViewInst.q5Desc.text = Constants.measureMetadata.longName(.q5)()
        self.equityDetailViewInst.q5DescTap.accessibilityLabel = "q5(\(equity.ticker))"
        Utilities.setStatusIcon(status: self.equity.q5Status, uiLabel: self.equityDetailViewInst.q5StatusDesc)
        
        // q6 label
        self.equityDetailViewInst.q6Desc.text = Constants.measureMetadata.longName(.q6)()
        self.equityDetailViewInst.q6DescTap.accessibilityLabel = "q6(\(equity.ticker))"
        Utilities.setStatusIcon(status: self.equity.q6Status, uiLabel: self.equityDetailViewInst.q6StatusDesc)
    }
}
