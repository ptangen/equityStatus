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
        if let company = self.company {
        
                 // if you add some getters to the company object, you may be able to get the value of these properties
            setLabelsInRow(
                
                measureName:    "eps_i",
                measureValue:   company.eps_i as NSNumber?,
                measurePassed:  company.eps_i_passed,
                measureLabel:   companyDetailViewInst.eps_i_ResultDesc,
                measureTap:     companyDetailViewInst.eps_i_ResultDescTap,
                statusLabel:    companyDetailViewInst.eps_i_StatusDesc
            )

            setLabelsInRow(
                measureName:    "eps_sd",
                measureValue:   self.company.eps_sd as NSNumber?,
                measurePassed:  self.company.eps_sd_passed,
                measureLabel:   self.companyDetailViewInst.eps_sd_ResultDesc,
                measureTap:     self.companyDetailViewInst.eps_sd_ResultDescTap,
                statusLabel:    self.companyDetailViewInst.eps_sd_StatusDesc
            )
            
            setLabelsInRow(
                measureName:    "roe_avg",
                measureValue:   self.company.roe_avg as NSNumber?,
                measurePassed:  self.company.roe_avg_passed,
                measureLabel:   self.companyDetailViewInst.roe_avg_ResultDesc,
                measureTap:     self.companyDetailViewInst.roe_avg_ResultDescTap,
                statusLabel:    self.companyDetailViewInst.roe_avg_StatusDesc
            )
            
            setLabelsInRow(
                measureName:    "bv_i",
                measureValue:   self.company.bv_i as NSNumber?,
                measurePassed:  self.company.bv_i_passed,
                measureLabel:   self.companyDetailViewInst.bv_i_ResultDesc,
                measureTap:     self.companyDetailViewInst.bv_i_ResultDescTap,
                statusLabel:    self.companyDetailViewInst.bv_i_StatusDesc
            )
            
            setLabelsInRow(
                measureName:    "dr_avg",
                measureValue:   self.company.dr_avg as NSNumber?,
                measurePassed:  self.company.dr_avg_passed,
                measureLabel:   self.companyDetailViewInst.dr_avg_ResultDesc,
                measureTap:     self.companyDetailViewInst.dr_avg_ResultDescTap,
                statusLabel:    self.companyDetailViewInst.dr_avg_StatusDesc
            )
            
            setLabelsInRow(
                measureName:    "so_reduced",
                measureValue:   self.company.so_reduced as NSNumber?,
                measurePassed:  self.company.so_reduced_passed,
                measureLabel:   self.companyDetailViewInst.so_reduced_ResultDesc,
                measureTap:     self.companyDetailViewInst.so_reduced_ResultDescTap,
                statusLabel:    self.companyDetailViewInst.so_reduced_StatusDesc
            )
            
            setLabelsInRow(
                measureName:    "pe_change",
                measureValue:   self.company.pe_change as NSNumber?,
                measurePassed:  self.company.pe_change_passed,
                measureLabel:   self.companyDetailViewInst.pe_change_ResultDesc,
                measureTap:     self.companyDetailViewInst.pe_change_ResultDescTap,
                statusLabel:    self.companyDetailViewInst.pe_change_StatusDesc
            )
            
            setLabelsInRow(
                measureName:    "previous_roi",
                measureValue:   self.company.previous_roi as NSNumber?,
                measurePassed:  self.company.previous_roi_passed,
                measureLabel:   self.companyDetailViewInst.previous_roi_ResultDesc,
                measureTap:     self.companyDetailViewInst.previous_roi_ResultDescTap,
                statusLabel:    self.companyDetailViewInst.previous_roi_StatusDesc
            )
            
            setLabelsInRow(
                measureName:    "expected_roi",
                measureValue:   self.company.expected_roi as NSNumber?,
                measurePassed:  self.company.expected_roi_passed,
                measureLabel:   self.companyDetailViewInst.expected_roi_ResultDesc,
                measureTap:     self.companyDetailViewInst.expected_roi_ResultDescTap,
                statusLabel:    self.companyDetailViewInst.expected_roi_StatusDesc
            )
            
            setLabelsInRow(
                measureName:    "q1",
                measureValue:   nil,
                measurePassed:  self.company.q1_passed,
                measureLabel:   self.companyDetailViewInst.q1_Desc,
                measureTap:     self.companyDetailViewInst.q1_DescTap,
                statusLabel:    self.companyDetailViewInst.q1_StatusDesc
            )
            
            setLabelsInRow(
                measureName:    "q2",
                measureValue:   nil,
                measurePassed:  self.company.q2_passed,
                measureLabel:   self.companyDetailViewInst.q2_Desc,
                measureTap:     self.companyDetailViewInst.q2_DescTap,
                statusLabel:    self.companyDetailViewInst.q2_StatusDesc
            )
            
            setLabelsInRow(
                measureName:    "q3",
                measureValue:   nil,
                measurePassed:  self.company.q3_passed,
                measureLabel:   self.companyDetailViewInst.q3_Desc,
                measureTap:     self.companyDetailViewInst.q3_DescTap,
                statusLabel:    self.companyDetailViewInst.q3_StatusDesc
            )
            
            setLabelsInRow(
                measureName:    "q4",
                measureValue:   nil,
                measurePassed:  self.company.q4_passed,
                measureLabel:   self.companyDetailViewInst.q4_Desc,
                measureTap:     self.companyDetailViewInst.q4_DescTap,
                statusLabel:    self.companyDetailViewInst.q4_StatusDesc
            )
            
            setLabelsInRow(
                measureName:    "q5",
                measureValue:   nil,
                measurePassed:  self.company.q5_passed,
                measureLabel:   self.companyDetailViewInst.q5_Desc,
                measureTap:     self.companyDetailViewInst.q5_DescTap,
                statusLabel:    self.companyDetailViewInst.q5_StatusDesc
            )
            
            setLabelsInRow(
                measureName:    "q6",
                measureValue:   nil,
                measurePassed:  self.company.q6_passed,
                measureLabel:   self.companyDetailViewInst.q6_Desc,
                measureTap:     self.companyDetailViewInst.q6_DescTap,
                statusLabel:    self.companyDetailViewInst.q6_StatusDesc
            )
            
            setLabelsInRow(
                measureName:    "own",
                measureValue:   nil,
                measurePassed:  self.company.own_passed,
                measureLabel:   self.companyDetailViewInst.own_Desc,
                measureTap:     self.companyDetailViewInst.own_DescTap,
                statusLabel:    self.companyDetailViewInst.own_StatusDesc
            )
        }
    }
}
