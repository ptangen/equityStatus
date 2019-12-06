//
//  CompanyDetailViewController.swift
//  EquityStatus
//
//  Created by Paul Tangen on 12/29/16.
//  Copyright © 2016 Paul Tangen. All rights reserved.
//

import UIKit

class CompanyDetailViewController: UIViewController, CompanyDetailViewDelegate {
    
    var companyDetailViewInst = CompanyDetailView()
    var company: Company!
    var measure = String()
    let store = DataStore.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        self.companyDetailViewInst.delegate = self
        self.navigationItem.backBarButtonItem?.accessibilityLabel = "backButton"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.backItem?.title = ""
        self.popualateLabels()
        self.title = "\(company.name.capitalized) (\(self.company.ticker))"
    }

    override func loadView(){
        self.companyDetailViewInst.frame = CGRect.zero
        self.companyDetailViewInst.company = self.company
        self.view = self.companyDetailViewInst
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func openMeasureDetail(measure: String) {
        let measurePageViewControllerInst = MeasurePageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        measurePageViewControllerInst.company = company
        measurePageViewControllerInst.measure = measure
        self.title = "" // this value is passed to the back button label in the destination VC
        navigationController?.pushViewController(measurePageViewControllerInst, animated: true) // show destination with nav bar
    }
    
    func popualateLabels() {
        
        // roe_avg label
        if let roe_avg = self.company.roe_avg, let roe_avg_passed = self.company.roe_avg_passed {
            let measureInfo = self.store.measureInfo["roe_avg"]!
            self.companyDetailViewInst.ROEaResultDesc.text = measureInfo["longName"]! + ": " + String(describing: roe_avg) + "%"
            self.companyDetailViewInst.ROEaResultDescTap.accessibilityLabel = measureInfo["name"]!
            Utilities.getStatusIcon(status: roe_avg_passed, uiLabel: self.companyDetailViewInst.ROEaStatusDesc)
        }
        
        // eps_i label
        if let eps_i = self.company.eps_i, let eps_i_passed = self.company.eps_i_passed {
            let measureInfo = self.store.measureInfo["eps_i"]!
            self.companyDetailViewInst.EPSiResultDesc.text = measureInfo["longName"]! + ": " + String(describing: eps_i) + "%"
            self.companyDetailViewInst.EPSiResultDescTap.accessibilityLabel = measureInfo["name"]!
            Utilities.getStatusIcon(status: eps_i_passed, uiLabel: self.companyDetailViewInst.EPSiStatusDesc)
        }
        
        // eps_sd label
        if let eps_sd = self.company.eps_sd, let eps_sd_passed = self.company.eps_sd_passed {
            let measureInfo = self.store.measureInfo["eps_sd"]!
            self.companyDetailViewInst.EPSvResultDesc.text = measureInfo["longName"]! + ": " + String(describing: eps_sd)
            self.companyDetailViewInst.EPSvResultDescTap.accessibilityLabel = measureInfo["name"]!
            Utilities.getStatusIcon(status: eps_sd_passed, uiLabel: self.companyDetailViewInst.EPSvStatusDesc)
        }
        
        // bv_i label
        if let bv_i = self.company.bv_i, let bv_i_passed = self.company.bv_i_passed {
            let measureInfo = self.store.measureInfo["bv_i"]!
            self.companyDetailViewInst.BViResultDesc.text = measureInfo["longName"]! + ": " + String(describing: bv_i) + "%"
            self.companyDetailViewInst.BViResultDescTap.accessibilityLabel = measureInfo["name"]!
            Utilities.getStatusIcon(status: bv_i_passed, uiLabel: self.companyDetailViewInst.BViStatusDesc)
        }
        
        // dr_avg label
        if let dr_avg = self.company.dr_avg, let dr_avg_passed = self.company.dr_avg_passed {
            let measureInfo = self.store.measureInfo["dr_avg"]!
            self.companyDetailViewInst.DRaResultDesc.text = measureInfo["longName"]! + ": " + String(describing: dr_avg)
            self.companyDetailViewInst.DRaResultDescTap.accessibilityLabel = measureInfo["name"]!
            Utilities.getStatusIcon(status: dr_avg_passed, uiLabel: self.companyDetailViewInst.DRaStatusDesc)
        }
        
        // so_reduced label
        if let so_reduced = self.company.so_reduced, let so_reduced_passed = self.company.so_reduced_passed {
            let measureInfo = self.store.measureInfo["so_reduced"]!
            self.companyDetailViewInst.SOrResultDesc.text = measureInfo["longName"]! + ": " + String(describing: so_reduced)
            self.companyDetailViewInst.SOrResultDescTap.accessibilityLabel = measureInfo["name"]!
            Utilities.getStatusIcon(status: so_reduced_passed, uiLabel: self.companyDetailViewInst.SOrStatusDesc)
        }
        
        
        // previous_roi label
        if let previous_roi = self.company.previous_roi, let previous_roi_passed = self.company.previous_roi_passed {
            let measureInfo = self.store.measureInfo["previous_roi"]!
            self.companyDetailViewInst.previousROIResultDesc.text = measureInfo["longName"]! + ": " + String(describing: previous_roi) + "%"
            self.companyDetailViewInst.previousROIResultDescTap.accessibilityLabel = measureInfo["name"]!
            Utilities.getStatusIcon(status: previous_roi_passed, uiLabel: self.companyDetailViewInst.previousROIStatusDesc)
        }
        
        // expected_roi label
        if let expected_roi = self.company.expected_roi, let expected_roi_passed = self.company.expected_roi_passed {
            let measureInfo = self.store.measureInfo["expected_roi"]!
            self.companyDetailViewInst.expectedROIResultDesc.text = measureInfo["longName"]! + ": " + String(describing: expected_roi) + "%"
            self.companyDetailViewInst.expectedROIResultDescTap.accessibilityLabel = measureInfo["name"]!
            Utilities.getStatusIcon(status: expected_roi_passed, uiLabel: self.companyDetailViewInst.expectedROIStatusDesc)
        }
            
        // q1 label
        self.companyDetailViewInst.q1Desc.text = self.store.measureInfo["q1"]!["longName"]!
        self.companyDetailViewInst.q1DescTap.accessibilityLabel = "q1(\(company.ticker))"
        Utilities.getStatusIcon(status: self.company.q1_passed, uiLabel: self.companyDetailViewInst.q1StatusDesc)
        
        // q2 label
        self.companyDetailViewInst.q2Desc.text = self.store.measureInfo["q2"]!["longName"]!
        self.companyDetailViewInst.q2DescTap.accessibilityLabel = "q2(\(company.ticker))"
        Utilities.getStatusIcon(status: self.company.q2_passed, uiLabel: self.companyDetailViewInst.q2StatusDesc)
        
        // q3 label
        self.companyDetailViewInst.q3Desc.text = self.store.measureInfo["q3"]!["longName"]!
        self.companyDetailViewInst.q3DescTap.accessibilityLabel = "q3(\(company.ticker))"
        Utilities.getStatusIcon(status: self.company.q3_passed, uiLabel: self.companyDetailViewInst.q3StatusDesc)
        
        // q4 label
        self.companyDetailViewInst.q4Desc.text = self.store.measureInfo["q4"]!["longName"]!
        self.companyDetailViewInst.q4DescTap.accessibilityLabel = "q4(\(company.ticker))"
        Utilities.getStatusIcon(status: self.company.q4_passed, uiLabel: self.companyDetailViewInst.q4StatusDesc)
        
        // q5 label
        self.companyDetailViewInst.q5Desc.text = self.store.measureInfo["q5"]!["longName"]!
        self.companyDetailViewInst.q5DescTap.accessibilityLabel = "q5(\(company.ticker))"
        Utilities.getStatusIcon(status: self.company.q5_passed, uiLabel: self.companyDetailViewInst.q5StatusDesc)
        
        // q6 label
        self.companyDetailViewInst.q6Desc.text = self.store.measureInfo["q6"]!["longName"]!
        self.companyDetailViewInst.q6DescTap.accessibilityLabel = "q6(\(company.ticker))"
        Utilities.getStatusIcon(status: self.company.q6_passed, uiLabel: self.companyDetailViewInst.q6StatusDesc)
    }
}
