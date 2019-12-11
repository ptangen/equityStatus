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
        self.getValuesAndLabels()
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
        print("openMeasureDetail measure: \(measure)")
        self.title = "" // this value is passed to the back button label in the destination VC
        navigationController?.pushViewController(measurePageViewControllerInst, animated: true) // show destination with nav bar
    }
    
    func setLabelsInRow(measureName: String, measureValue:NSNumber?, measurePassed: Bool?, measureLabel: UILabel, measureTap: UITapGestureRecognizer, statusLabel: UILabel){
        
        var measureValueString = String()
        let measureInfo = self.store.measureInfo[measureName]!
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        // create the value string
        if let measureValueUnwrapped = measureValue{
            measureValueString = ": " + formatter.string(from: measureValueUnwrapped)! + measureInfo["units"]!
        }
        
        Utilities.getStatusIcon(status: measurePassed, uiLabel: statusLabel)
        measureLabel.text = measureInfo["longName"]! + measureValueString
        measureTap.accessibilityLabel = measureInfo["name"]!
    }

    func getValuesAndLabels() {
        
        setLabelsInRow(
            measureName:    "eps_i",
            measureValue:   self.company.eps_i as NSNumber?,
            measurePassed:  self.company.eps_i_passed,
            measureLabel:   self.companyDetailViewInst.EPSiResultDesc,
            measureTap:     self.companyDetailViewInst.EPSiResultDescTap,
            statusLabel:    self.companyDetailViewInst.EPSiStatusDesc
        )

        setLabelsInRow(
            measureName:    "eps_sd",
            measureValue:   self.company.eps_sd as NSNumber?,
            measurePassed:  self.company.eps_sd_passed,
            measureLabel:   self.companyDetailViewInst.EPSvResultDesc,
            measureTap:     self.companyDetailViewInst.EPSvResultDescTap,
            statusLabel:    self.companyDetailViewInst.EPSvStatusDesc
        )
        
        setLabelsInRow(
            measureName:    "roe_avg",
            measureValue:   self.company.roe_avg as NSNumber?,
            measurePassed:  self.company.roe_avg_passed,
            measureLabel:   self.companyDetailViewInst.ROEaResultDesc,
            measureTap:     self.companyDetailViewInst.ROEaResultDescTap,
            statusLabel:    self.companyDetailViewInst.ROEaStatusDesc
        )
        
        setLabelsInRow(
            measureName:    "bv_i",
            measureValue:   self.company.bv_i as NSNumber?,
            measurePassed:  self.company.bv_i_passed,
            measureLabel:   self.companyDetailViewInst.BViResultDesc,
            measureTap:     self.companyDetailViewInst.BViResultDescTap,
            statusLabel:    self.companyDetailViewInst.BViStatusDesc
        )
        
        setLabelsInRow(
            measureName:    "dr_avg",
            measureValue:   self.company.dr_avg as NSNumber?,
            measurePassed:  self.company.dr_avg_passed,
            measureLabel:   self.companyDetailViewInst.DRaResultDesc,
            measureTap:     self.companyDetailViewInst.DRaResultDescTap,
            statusLabel:    self.companyDetailViewInst.DRaStatusDesc
        )
        
        setLabelsInRow(
            measureName:    "so_reduced",
            measureValue:   self.company.so_reduced as NSNumber?,
            measurePassed:  self.company.so_reduced_passed,
            measureLabel:   self.companyDetailViewInst.SOrResultDesc,
            measureTap:     self.companyDetailViewInst.SOrResultDescTap,
            statusLabel:    self.companyDetailViewInst.SOrStatusDesc
        )
        
        setLabelsInRow(
            measureName:    "previous_roi",
            measureValue:   self.company.previous_roi as NSNumber?,
            measurePassed:  self.company.previous_roi_passed,
            measureLabel:   self.companyDetailViewInst.previousROIResultDesc,
            measureTap:     self.companyDetailViewInst.previousROIResultDescTap,
            statusLabel:    self.companyDetailViewInst.previousROIStatusDesc
        )
        
        setLabelsInRow(
            measureName:    "expected_roi",
            measureValue:   self.company.expected_roi as NSNumber?,
            measurePassed:  self.company.expected_roi_passed,
            measureLabel:   self.companyDetailViewInst.expectedROIResultDesc,
            measureTap:     self.companyDetailViewInst.expectedROIResultDescTap,
            statusLabel:    self.companyDetailViewInst.expectedROIStatusDesc
        )
        
        setLabelsInRow(
            measureName:    "q1",
            measureValue:   nil,
            measurePassed:  self.company.q1_passed,
            measureLabel:   self.companyDetailViewInst.q1Desc,
            measureTap:     self.companyDetailViewInst.q1DescTap,
            statusLabel:    self.companyDetailViewInst.q1StatusDesc
        )
        
        setLabelsInRow(
            measureName:    "q2",
            measureValue:   nil,
            measurePassed:  self.company.q2_passed,
            measureLabel:   self.companyDetailViewInst.q2Desc,
            measureTap:     self.companyDetailViewInst.q2DescTap,
            statusLabel:    self.companyDetailViewInst.q2StatusDesc
        )
        
        setLabelsInRow(
            measureName:    "q3",
            measureValue:   nil,
            measurePassed:  self.company.q3_passed,
            measureLabel:   self.companyDetailViewInst.q3Desc,
            measureTap:     self.companyDetailViewInst.q3DescTap,
            statusLabel:    self.companyDetailViewInst.q3StatusDesc
        )
        
        setLabelsInRow(
            measureName:    "q4",
            measureValue:   nil,
            measurePassed:  self.company.q4_passed,
            measureLabel:   self.companyDetailViewInst.q4Desc,
            measureTap:     self.companyDetailViewInst.q4DescTap,
            statusLabel:    self.companyDetailViewInst.q4StatusDesc
        )
        
        setLabelsInRow(
            measureName:    "q5",
            measureValue:   nil,
            measurePassed:  self.company.q5_passed,
            measureLabel:   self.companyDetailViewInst.q5Desc,
            measureTap:     self.companyDetailViewInst.q5DescTap,
            statusLabel:    self.companyDetailViewInst.q5StatusDesc
        )
        
        setLabelsInRow(
            measureName:    "q6",
            measureValue:   nil,
            measurePassed:  self.company.q6_passed,
            measureLabel:   self.companyDetailViewInst.q6Desc,
            measureTap:     self.companyDetailViewInst.q6DescTap,
            statusLabel:    self.companyDetailViewInst.q6StatusDesc
        )
    }
}
