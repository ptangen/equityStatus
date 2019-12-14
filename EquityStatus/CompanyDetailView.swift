//
//  CompanyDetailView.swift
//  EquityStatus
//
//  Created by Paul Tangen on 12/29/16.
//  Copyright © 2016 Paul Tangen. All rights reserved.
//

import UIKit

protocol CompanyDetailViewDelegate: class {
    func openMeasureDetail(measure: String)
}

class CompanyDetailView: UIView {

    weak var delegate: CompanyDetailViewDelegate?
    var company: Company!
    let scrollView = UIScrollView()
    var heightOfScrolledContent = CGFloat()
    var measure = String()
    
    let lineSpacing:CGFloat = 18
    
    let subTitle = UILabel()
    
    let eps_i_ResultDesc = UILabel()
    let eps_i_ResultDescTap = UITapGestureRecognizer()
    let eps_i_StatusDesc = UILabel()
    
    let eps_sd_ResultDesc = UILabel()
    let eps_sd_ResultDescTap = UITapGestureRecognizer()
    let eps_sd_StatusDesc = UILabel()
    
    let roe_avg_ResultDesc = UILabel()
    let roe_avg_ResultDescTap = UITapGestureRecognizer()
    let roe_avg_StatusDesc = UILabel()
    
    let bv_i_ResultDesc = UILabel()
    let bv_i_ResultDescTap = UITapGestureRecognizer()
    let bv_i_StatusDesc = UILabel()
    
    let dr_avg_ResultDesc = UILabel()
    let dr_avg_ResultDescTap = UITapGestureRecognizer()
    let dr_avg_StatusDesc = UILabel()
    
    let so_reduced_ResultDesc = UILabel()
    let so_reduced_ResultDescTap = UITapGestureRecognizer()
    let so_reduced_StatusDesc = UILabel()
    
    let previous_roi_ResultDesc = UILabel()
    let previous_roi_ResultDescTap = UITapGestureRecognizer()
    let previous_roi_StatusDesc = UILabel()
    
    let expected_roi_ResultDesc = UILabel()
    let expected_roi_ResultDescTap = UITapGestureRecognizer()
    let expected_roi_StatusDesc = UILabel()
    
    let q1_Desc = UILabel()
    let q1_DescTap = UITapGestureRecognizer()
    let q1_StatusDesc = UILabel()
    
    let q2_Desc = UILabel()
    let q2_DescTap = UITapGestureRecognizer()
    let q2_StatusDesc = UILabel()
    
    let q3_Desc = UILabel()
    let q3_DescTap = UITapGestureRecognizer()
    let q3_StatusDesc = UILabel()
    
    let q4_Desc = UILabel()
    let q4_DescTap = UITapGestureRecognizer()
    let q4_StatusDesc = UILabel()
    
    let q5_Desc = UILabel()
    let q5_DescTap = UITapGestureRecognizer()
    let q5_StatusDesc = UILabel()
    
    let q6_Desc = UILabel()
    let q6_DescTap = UITapGestureRecognizer()
    let q6_StatusDesc = UILabel()
    
    override init(frame:CGRect){
        super.init(frame: frame)
        // the 5 and SE devices (width=320) need more vertical space
        UIScreen.main.bounds.width == 320 ? (self.heightOfScrolledContent = 800) : (self.heightOfScrolledContent = 700)
        self.pageLayout()
        self.accessibilityLabel = "equityDetailViewInst"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func pageLayout() {
        
        self.addSubview(self.scrollView)
        self.scrollView.backgroundColor = UIColor.black
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.backgroundColor = UIColor.white
        self.scrollView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        self.scrollView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        self.scrollView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        self.scrollView.autoresizingMask = [.flexibleRightMargin, .flexibleLeftMargin, .flexibleBottomMargin]
        self.scrollView.contentSize = CGSize(width: self.bounds.width, height: self.heightOfScrolledContent)
        
        // subtitle
        self.scrollView.addSubview(self.subTitle)
        self.subTitle.translatesAutoresizingMaskIntoConstraints = false
        self.subTitle.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 36).isActive = true
        self.subTitle.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor, constant: 10).isActive = true
        self.subTitle.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        self.subTitle.text = "Review the measures for this equity and provide values for measures with undefined values."
        self.subTitle.font = UIFont(name: Constants.appFont.regular.rawValue, size: Constants.fontSize.small.rawValue)
        self.subTitle.numberOfLines = 0
        
        // EPSiResultsDesc
        self.scrollView.addSubview(self.eps_i_ResultDesc)
        self.eps_i_ResultDesc.translatesAutoresizingMaskIntoConstraints = false
        self.eps_i_ResultDesc.topAnchor.constraint(equalTo: self.subTitle.bottomAnchor, constant: 36).isActive = true
        self.eps_i_ResultDesc.leftAnchor.constraint(equalTo: self.subTitle.leftAnchor, constant: 30).isActive = true
        self.eps_i_ResultDesc.rightAnchor.constraint(equalTo: self.subTitle.rightAnchor).isActive = true
        self.eps_i_ResultDesc.numberOfLines = 0
        self.eps_i_ResultDesc.font = UIFont(name: Constants.appFont.regular.rawValue, size: Constants.fontSize.small.rawValue)
        self.eps_i_ResultDescTap.addTarget(self, action: #selector(self.onClickLineItem))
        self.eps_i_ResultDesc.isUserInteractionEnabled = true
        self.eps_i_ResultDesc.addGestureRecognizer(eps_i_ResultDescTap)
        
        // EPSiStatusDesc
        self.scrollView.addSubview(self.eps_i_StatusDesc)
        self.eps_i_StatusDesc.translatesAutoresizingMaskIntoConstraints = false
        self.eps_i_StatusDesc.topAnchor.constraint(equalTo: self.eps_i_ResultDesc.topAnchor, constant: 0).isActive = true
        self.eps_i_StatusDesc.rightAnchor.constraint(equalTo: self.eps_i_ResultDesc.leftAnchor, constant: -10).isActive = true
        self.eps_i_StatusDesc.font = UIFont(name: Constants.iconFont.fontAwesome.rawValue, size: Constants.iconSize.xsmall.rawValue)
        
        // after the row for the first measure is in place, the other rows can be added through the function

        // eps_sd
        self.addRowForMeasure(
            resultDesc:         self.eps_sd_ResultDesc,
            previousResultDesc: self.eps_i_ResultDesc,
            resultDescTap:      self.eps_sd_ResultDescTap,
            statusDesc:         self.eps_sd_StatusDesc
        )

        // roe_avg
        self.addRowForMeasure(
            resultDesc:         self.roe_avg_ResultDesc,
            previousResultDesc: self.eps_sd_ResultDesc,
            resultDescTap:      self.roe_avg_ResultDescTap,
            statusDesc:         self.roe_avg_StatusDesc
        )
        
        // bv_i
        self.addRowForMeasure(
            resultDesc:         self.bv_i_ResultDesc,
            previousResultDesc: self.roe_avg_ResultDesc,
            resultDescTap:      self.bv_i_ResultDescTap,
            statusDesc:         self.bv_i_StatusDesc
        )
        
        // dr_avg
        self.addRowForMeasure(
            resultDesc:         self.dr_avg_ResultDesc,
            previousResultDesc: self.bv_i_ResultDesc,
            resultDescTap:      self.dr_avg_ResultDescTap,
            statusDesc:         self.dr_avg_StatusDesc
        )
        
        // so_reduced
        self.addRowForMeasure(
            resultDesc:         self.so_reduced_ResultDesc,
            previousResultDesc: self.dr_avg_ResultDesc,
            resultDescTap:      self.so_reduced_ResultDescTap,
            statusDesc:         self.so_reduced_StatusDesc
        )
        
        // previous_roi
        self.addRowForMeasure(
            resultDesc:         self.previous_roi_ResultDesc,
            previousResultDesc: self.so_reduced_ResultDesc,
            resultDescTap:      self.previous_roi_ResultDescTap,
            statusDesc:         self.previous_roi_StatusDesc
        )
        
        // expected_roi
        self.addRowForMeasure(
            resultDesc:         self.expected_roi_ResultDesc,
            previousResultDesc: self.previous_roi_ResultDesc,
            resultDescTap:      self.expected_roi_ResultDescTap,
            statusDesc:         self.expected_roi_StatusDesc
        )
        
        // q1
        self.addRowForMeasure(
            resultDesc:         self.q1_Desc,
            previousResultDesc: self.expected_roi_ResultDesc,
            resultDescTap:      self.q1_DescTap,
            statusDesc:         self.q1_StatusDesc
        )
        
        // q2
        self.addRowForMeasure(
            resultDesc:         self.q2_Desc,
            previousResultDesc: self.q1_Desc,
            resultDescTap:      self.q2_DescTap,
            statusDesc:         self.q2_StatusDesc
        )
        
        // q3
        self.addRowForMeasure(
            resultDesc:         self.q3_Desc,
            previousResultDesc: self.q2_Desc,
            resultDescTap:      self.q3_DescTap,
            statusDesc:         self.q3_StatusDesc
        )
        
        // q4
        self.addRowForMeasure(
            resultDesc:         self.q4_Desc,
            previousResultDesc: self.q3_Desc,
            resultDescTap:      self.q4_DescTap,
            statusDesc:         self.q4_StatusDesc
        )
        
        // q5
        self.addRowForMeasure(
            resultDesc:         self.q5_Desc,
            previousResultDesc: self.q4_Desc,
            resultDescTap:      self.q5_DescTap,
            statusDesc:         self.q5_StatusDesc
        )
        
        // q6
        self.addRowForMeasure(
            resultDesc:         self.q6_Desc,
            previousResultDesc: self.q5_Desc,
            resultDescTap:      self.q6_DescTap,
            statusDesc:         self.q6_StatusDesc
        )
    }
    
    func addRowForMeasure(resultDesc: UILabel, previousResultDesc: UILabel, resultDescTap: UITapGestureRecognizer, statusDesc: UILabel){
        // BViResultDesc
        self.scrollView.addSubview(resultDesc)
        resultDesc.translatesAutoresizingMaskIntoConstraints = false
        resultDesc.topAnchor.constraint(equalTo: previousResultDesc.bottomAnchor, constant: self.lineSpacing).isActive = true
        resultDesc.leftAnchor.constraint(equalTo: previousResultDesc.leftAnchor).isActive = true
        resultDesc.rightAnchor.constraint(equalTo: previousResultDesc.rightAnchor).isActive = true
        resultDesc.numberOfLines = 0
        resultDesc.font = UIFont(name: Constants.appFont.regular.rawValue, size: Constants.fontSize.small.rawValue)
        resultDescTap.addTarget(self, action: #selector(self.onClickLineItem))
        resultDesc.isUserInteractionEnabled = true
        resultDesc.addGestureRecognizer(resultDescTap)
        
        // BViStatusDesc
        self.scrollView.addSubview(statusDesc)
        statusDesc.translatesAutoresizingMaskIntoConstraints = false
        statusDesc.topAnchor.constraint(equalTo: resultDesc.topAnchor, constant: 0).isActive = true
        statusDesc.rightAnchor.constraint(equalTo: resultDesc.leftAnchor, constant: -10).isActive = true
        statusDesc.font = UIFont(name: Constants.iconFont.fontAwesome.rawValue, size: Constants.iconSize.xsmall.rawValue)
    }
    
    @objc func onClickLineItem(sender: UILabel){
        if let measure = sender.accessibilityLabel {
            self.delegate?.openMeasureDetail(measure: measure)
        }
    }
}
