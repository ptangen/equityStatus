//
//  EquityDetailViewController.swift
//  EquityStatus
//
//  Created by Paul Tangen on 12/29/16.
//  Copyright © 2016 Paul Tangen. All rights reserved.
//

import UIKit

class EquityDetailViewController: UIViewController, EquityDetailViewDelegate {
    
    var equityDetailViewInst: EquityDetailView!
    var equity: Equity!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.equityDetailViewInst.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.backItem?.title = ""
        self.popualateLabels()
        self.title = "\(equity.name) (\(self.equity.ticker))"
    }

    override func loadView(){
        self.equityDetailViewInst = EquityDetailView(frame: CGRect.zero)
        self.equityDetailViewInst.equity = self.equity
        self.view = self.equityDetailViewInst
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func openMeasureDetail(_ measureTicker: String) {
        let measureDetailViewControllerInst = MeasureDetailViewController()
        measureDetailViewControllerInst.measureTicker = measureTicker
        self.title = "" // this value is passed to the back button label in the destination VC
        navigationController?.pushViewController(measureDetailViewControllerInst, animated: true) // show destination with nav bar
    }
    
    func popualateLabels() {
        
        // ROEaResult label
        if self.equity.ROEaResult == -1000 {
            self.equityDetailViewInst.ROEaResultDesc.text = "\(Constants.measureLongName.ROEa.rawValue): no data"
        } else {
            self.equityDetailViewInst.ROEaResultDesc.text = "\(Constants.measureLongName.ROEa.rawValue): \(self.equity.ROEaResult)%"
        }
        self.equityDetailViewInst.ROEaResultDescTap.accessibilityLabel = "ROEa(\(equity.ticker))"
        Utilities.setStatusIcon(status: self.equity.ROEaStatus, uiLabel: self.equityDetailViewInst.ROEaStatusDesc)
        
        // EPSiResult label
        if self.equity.EPSiResult == -1000 {
            self.equityDetailViewInst.EPSiResultDesc.text = "\(Constants.measureLongName.EPSi.rawValue): no data"
        } else {
            self.equityDetailViewInst.EPSiResultDesc.text = "\(Constants.measureLongName.EPSi.rawValue): \(self.equity.EPSiResult)%"
        }
        self.equityDetailViewInst.EPSiResultDescTap.accessibilityLabel = "EPSi(\(equity.ticker))"
        Utilities.setStatusIcon(status: self.equity.EPSiStatus, uiLabel: self.equityDetailViewInst.EPSiStatusDesc)
        
        // EPSvResult label
        if self.equity.EPSvResult == -1000 {
            self.equityDetailViewInst.EPSvResultDesc.text = "\(Constants.measureLongName.EPSv.rawValue): no data"
        } else {
            self.equityDetailViewInst.EPSvResultDesc.text = "\(Constants.measureLongName.EPSv.rawValue): \(self.equity.EPSvResult)"
        }
        self.equityDetailViewInst.EPSvResultDescTap.accessibilityLabel = "EPSv(\(equity.ticker))"
        Utilities.setStatusIcon(status: self.equity.EPSvStatus, uiLabel: self.equityDetailViewInst.EPSvStatusDesc)
        
        // BViResult label
        if self.equity.BViResult == -1000 {
            self.equityDetailViewInst.BViResultDesc.text = "\(Constants.measureLongName.BVi.rawValue): no data"
        } else {
            self.equityDetailViewInst.BViResultDesc.text = "\(Constants.measureLongName.BVi.rawValue): \(self.equity.BViResult)%"
        }
        self.equityDetailViewInst.BViResultDescTap.accessibilityLabel = "BVi(\(equity.ticker))"
        Utilities.setStatusIcon(status: self.equity.BViStatus, uiLabel: self.equityDetailViewInst.BViStatusDesc)
        
        // DRaResult label
        if self.equity.DRaResult == -1000 {
            self.equityDetailViewInst.DRaResultDesc.text = "\(Constants.measureLongName.DRa.rawValue): no data"
        } else {
            self.equityDetailViewInst.DRaResultDesc.text = "\(Constants.measureLongName.DRa.rawValue): \(self.equity.DRaResult)"
        }
        self.equityDetailViewInst.DRaResultDescTap.accessibilityLabel = "DRa(\(equity.ticker))"
        Utilities.setStatusIcon(status: self.equity.DRaStatus, uiLabel: self.equityDetailViewInst.DRaStatusDesc)
        
        // SOrResult label
        if self.equity.SOrResult == -1000 {
            self.equityDetailViewInst.SOrResultDesc.text = "\(Constants.measureLongName.SOr.rawValue): no data"
        } else {
            self.equityDetailViewInst.SOrResultDesc.text = "\(Constants.measureLongName.SOr.rawValue): \(self.equity.SOrResult)"
        }
        self.equityDetailViewInst.SOrResultDescTap.accessibilityLabel = "SOr(\(equity.ticker))"
        Utilities.setStatusIcon(status: self.equity.SOrStatus, uiLabel: self.equityDetailViewInst.SOrStatusDesc)
        
        // previousROIResult label
        if self.equity.previousROIResult == -1000 {
            self.equityDetailViewInst.previousROIResultDesc.text = "\(Constants.measureLongName.previousROI.rawValue): no data"
        } else {
            self.equityDetailViewInst.previousROIResultDesc.text = "\(Constants.measureLongName.previousROI.rawValue): \(self.equity.previousROIResult)%"
        }
        self.equityDetailViewInst.previousROIResultDescTap.accessibilityLabel = "previousROI(\(equity.ticker))"
        Utilities.setStatusIcon(status: self.equity.previousROIStatus, uiLabel: self.equityDetailViewInst.previousROIStatusDesc)
        
        // expectedROIResult label
        if self.equity.expectedROIResult == -1000 {
            self.equityDetailViewInst.expectedROIResultDesc.text = "\(Constants.measureLongName.expectedROI.rawValue): no data"
        } else {
            self.equityDetailViewInst.expectedROIResultDesc.text = "\(Constants.measureLongName.expectedROI.rawValue): \(self.equity.expectedROIResult)%"
        }
        self.equityDetailViewInst.expectedROIResultDescTap.accessibilityLabel = "expectedROI(\(equity.ticker))"
        Utilities.setStatusIcon(status: self.equity.expectedROIStatus, uiLabel: self.equityDetailViewInst.expectedROIStatusDesc)
        
        // q1 label
        self.equityDetailViewInst.q1Desc.text = Constants.measureLongName.q1.rawValue
        self.equityDetailViewInst.q1DescTap.accessibilityLabel = "q1(\(equity.ticker))"
        Utilities.setStatusIcon(status: self.equity.q1Status, uiLabel: self.equityDetailViewInst.q1StatusDesc)
        
        // q2 label
        self.equityDetailViewInst.q2Desc.text = Constants.measureLongName.q2.rawValue
        self.equityDetailViewInst.q2DescTap.accessibilityLabel = "q2(\(equity.ticker))"
        Utilities.setStatusIcon(status: self.equity.q2Status, uiLabel: self.equityDetailViewInst.q2StatusDesc)
        
        // q3 label
        self.equityDetailViewInst.q3Desc.text = Constants.measureLongName.q3.rawValue
        self.equityDetailViewInst.q3DescTap.accessibilityLabel = "q3(\(equity.ticker))"
        Utilities.setStatusIcon(status: self.equity.q3Status, uiLabel: self.equityDetailViewInst.q3StatusDesc)
        
        // q4 label
        self.equityDetailViewInst.q4Desc.text = Constants.measureLongName.q4.rawValue
        self.equityDetailViewInst.q4DescTap.accessibilityLabel = "q4(\(equity.ticker))"
        Utilities.setStatusIcon(status: self.equity.q4Status, uiLabel: self.equityDetailViewInst.q4StatusDesc)
        
        // q5 label
        self.equityDetailViewInst.q5Desc.text = Constants.measureLongName.q5.rawValue
        self.equityDetailViewInst.q5DescTap.accessibilityLabel = "q5(\(equity.ticker))"
        Utilities.setStatusIcon(status: self.equity.q5Status, uiLabel: self.equityDetailViewInst.q5StatusDesc)
        
        // q6 label
        self.equityDetailViewInst.q6Desc.text = Constants.measureLongName.q6.rawValue
        self.equityDetailViewInst.q6DescTap.accessibilityLabel = "q6(\(equity.ticker))"
        Utilities.setStatusIcon(status: self.equity.q6Status, uiLabel: self.equityDetailViewInst.q6StatusDesc)
    }
}
