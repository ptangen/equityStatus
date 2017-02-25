//
//  EquityDetailView.swift
//  EquityStatus
//
//  Created by Paul Tangen on 12/29/16.
//  Copyright © 2016 Paul Tangen. All rights reserved.
//

import UIKit

protocol EquityDetailViewDelegate: class {
    func openMeasureDetail(_: String)
}

class EquityDetailView: UIView {

    weak var delegate: EquityDetailViewDelegate?
    var equity: Equity!
    let scrollView = UIScrollView()
    var heightOfScrolledContent = CGFloat()
    
    let lineSpacing:CGFloat = 18
    
    let subTitle = UILabel()
    
    let ROEaResultDesc = UILabel()
    let ROEaResultDescTap = UITapGestureRecognizer()
    let ROEaStatusDesc = UILabel()
    
    let EPSiResultDesc = UILabel()
    let EPSiResultDescTap = UITapGestureRecognizer()
    let EPSiStatusDesc = UILabel()
    
    let EPSvResultDesc = UILabel()
    let EPSvResultDescTap = UITapGestureRecognizer()
    let EPSvStatusDesc = UILabel()
    
    let BViResultDesc = UILabel()
    let BViResultDescTap = UITapGestureRecognizer()
    let BViStatusDesc = UILabel()
    
    let DRaResultDesc = UILabel()
    let DRaResultDescTap = UITapGestureRecognizer()
    let DRaStatusDesc = UILabel()
    
    let SOrResultDesc = UILabel()
    let SOrResultDescTap = UITapGestureRecognizer()
    let SOrStatusDesc = UILabel()
    
    let previousROIResultDesc = UILabel()
    let previousROIResultDescTap = UITapGestureRecognizer()
    let previousROIStatusDesc = UILabel()
    
    let expectedROIResultDesc = UILabel()
    let expectedROIResultDescTap = UITapGestureRecognizer()
    let expectedROIStatusDesc = UILabel()
    
    let q1Desc = UILabel()
    let q1DescTap = UITapGestureRecognizer()
    let q1StatusDesc = UILabel()
    
    let q2Desc = UILabel()
    let q2DescTap = UITapGestureRecognizer()
    let q2StatusDesc = UILabel()
    
    let q3Desc = UILabel()
    let q3DescTap = UITapGestureRecognizer()
    let q3StatusDesc = UILabel()
    
    let q4Desc = UILabel()
    let q4DescTap = UITapGestureRecognizer()
    let q4StatusDesc = UILabel()
    
    let q5Desc = UILabel()
    let q5DescTap = UITapGestureRecognizer()
    let q5StatusDesc = UILabel()
    
    let q6Desc = UILabel()
    let q6DescTap = UITapGestureRecognizer()
    let q6StatusDesc = UILabel()
    
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
        
        // ROEaResultsDesc
        self.scrollView.addSubview(self.ROEaResultDesc)
        self.ROEaResultDesc.translatesAutoresizingMaskIntoConstraints = false
        self.ROEaResultDesc.topAnchor.constraint(equalTo: self.subTitle.bottomAnchor, constant: 36).isActive = true
        self.ROEaResultDesc.leftAnchor.constraint(equalTo: self.subTitle.leftAnchor, constant: 30).isActive = true
        self.ROEaResultDesc.rightAnchor.constraint(equalTo: self.subTitle.rightAnchor, constant: -6).isActive = true
        self.ROEaResultDesc.numberOfLines = 0
        self.ROEaResultDesc.font = UIFont(name: Constants.appFont.regular.rawValue, size: Constants.fontSize.small.rawValue)
        self.ROEaResultDescTap.addTarget(self, action: #selector(self.onClickLineItem))
        self.ROEaResultDesc.isUserInteractionEnabled = true
        self.ROEaResultDesc.addGestureRecognizer(ROEaResultDescTap)
        
        // ROEaStatusDesc
        self.scrollView.addSubview(self.ROEaStatusDesc)
        self.ROEaStatusDesc.translatesAutoresizingMaskIntoConstraints = false
        self.ROEaStatusDesc.topAnchor.constraint(equalTo: self.ROEaResultDesc.topAnchor, constant: 0).isActive = true
        self.ROEaStatusDesc.rightAnchor.constraint(equalTo: self.ROEaResultDesc.leftAnchor, constant: -10).isActive = true
        self.ROEaStatusDesc.font = UIFont(name: Constants.iconFont.fontAwesome.rawValue, size: Constants.iconSize.xsmall.rawValue)
        
        // EPSiResultsDesc
        self.scrollView.addSubview(self.EPSiResultDesc)
        self.EPSiResultDesc.translatesAutoresizingMaskIntoConstraints = false
        self.EPSiResultDesc.topAnchor.constraint(equalTo: self.ROEaResultDesc.bottomAnchor, constant: self.lineSpacing).isActive = true
        self.EPSiResultDesc.leftAnchor.constraint(equalTo: self.ROEaResultDesc.leftAnchor).isActive = true
        self.EPSiResultDesc.rightAnchor.constraint(equalTo: self.ROEaResultDesc.rightAnchor).isActive = true
        self.EPSiResultDesc.numberOfLines = 0
        self.EPSiResultDesc.font = UIFont(name: Constants.appFont.regular.rawValue, size: Constants.fontSize.small.rawValue)
        self.EPSiResultDescTap.addTarget(self, action: #selector(self.onClickLineItem))
        self.EPSiResultDesc.isUserInteractionEnabled = true
        self.EPSiResultDesc.addGestureRecognizer(EPSiResultDescTap)
        
        // EPSiStatusDesc
        self.scrollView.addSubview(self.EPSiStatusDesc)
        self.EPSiStatusDesc.translatesAutoresizingMaskIntoConstraints = false
        self.EPSiStatusDesc.topAnchor.constraint(equalTo: self.EPSiResultDesc.topAnchor, constant: 0).isActive = true
        self.EPSiStatusDesc.rightAnchor.constraint(equalTo: self.EPSiResultDesc.leftAnchor, constant: -10).isActive = true
        self.EPSiStatusDesc.font = UIFont(name: Constants.iconFont.fontAwesome.rawValue, size: Constants.iconSize.xsmall.rawValue)
        
        // EPSvResultDesc
        self.scrollView.addSubview(self.EPSvResultDesc)
        self.EPSvResultDesc.translatesAutoresizingMaskIntoConstraints = false
        self.EPSvResultDesc.topAnchor.constraint(equalTo: self.EPSiResultDesc.bottomAnchor, constant: self.lineSpacing).isActive = true
        self.EPSvResultDesc.leftAnchor.constraint(equalTo: self.EPSiResultDesc.leftAnchor).isActive = true
        self.EPSvResultDesc.rightAnchor.constraint(equalTo: self.EPSiResultDesc.rightAnchor).isActive = true
        self.EPSvResultDesc.numberOfLines = 0
        self.EPSvResultDesc.font = UIFont(name: Constants.appFont.regular.rawValue, size: Constants.fontSize.small.rawValue)
        self.EPSvResultDescTap.addTarget(self, action: #selector(self.onClickLineItem))
        self.EPSvResultDesc.isUserInteractionEnabled = true
        self.EPSvResultDesc.addGestureRecognizer(EPSvResultDescTap)
        
        // EPSvStatusDesc
        self.scrollView.addSubview(self.EPSvStatusDesc)
        self.EPSvStatusDesc.translatesAutoresizingMaskIntoConstraints = false
        self.EPSvStatusDesc.topAnchor.constraint(equalTo: self.EPSvResultDesc.topAnchor, constant: 0).isActive = true
        self.EPSvStatusDesc.rightAnchor.constraint(equalTo: self.EPSvResultDesc.leftAnchor, constant: -10).isActive = true
        self.EPSvStatusDesc.font = UIFont(name: Constants.iconFont.fontAwesome.rawValue, size: Constants.iconSize.xsmall.rawValue)
        
        // BViResultDesc
        self.scrollView.addSubview(self.BViResultDesc)
        self.BViResultDesc.translatesAutoresizingMaskIntoConstraints = false
        self.BViResultDesc.topAnchor.constraint(equalTo: self.EPSvResultDesc.bottomAnchor, constant: self.lineSpacing).isActive = true
        self.BViResultDesc.leftAnchor.constraint(equalTo: self.EPSvResultDesc.leftAnchor).isActive = true
        self.BViResultDesc.rightAnchor.constraint(equalTo: self.EPSvResultDesc.rightAnchor).isActive = true
        self.BViResultDesc.numberOfLines = 0
        self.BViResultDesc.font = UIFont(name: Constants.appFont.regular.rawValue, size: Constants.fontSize.small.rawValue)
        self.BViResultDescTap.addTarget(self, action: #selector(self.onClickLineItem))
        self.BViResultDesc.isUserInteractionEnabled = true
        self.BViResultDesc.addGestureRecognizer(BViResultDescTap)
        
        // BViStatusDesc
        self.scrollView.addSubview(self.BViStatusDesc)
        self.BViStatusDesc.translatesAutoresizingMaskIntoConstraints = false
        self.BViStatusDesc.topAnchor.constraint(equalTo: self.BViResultDesc.topAnchor, constant: 0).isActive = true
        self.BViStatusDesc.rightAnchor.constraint(equalTo: self.BViResultDesc.leftAnchor, constant: -10).isActive = true
        self.BViStatusDesc.font = UIFont(name: Constants.iconFont.fontAwesome.rawValue, size: Constants.iconSize.xsmall.rawValue)
        
        // DRaResultDesc
        self.scrollView.addSubview(self.DRaResultDesc)
        self.DRaResultDesc.translatesAutoresizingMaskIntoConstraints = false
        self.DRaResultDesc.topAnchor.constraint(equalTo: self.BViResultDesc.bottomAnchor, constant: self.lineSpacing).isActive = true
        self.DRaResultDesc.leftAnchor.constraint(equalTo: self.BViResultDesc.leftAnchor).isActive = true
        self.DRaResultDesc.rightAnchor.constraint(equalTo: self.BViResultDesc.rightAnchor).isActive = true
        self.DRaResultDesc.numberOfLines = 0
        self.DRaResultDesc.font = UIFont(name: Constants.appFont.regular.rawValue, size: Constants.fontSize.small.rawValue)
        self.DRaResultDescTap.addTarget(self, action: #selector(self.onClickLineItem))
        self.DRaResultDesc.isUserInteractionEnabled = true
        self.DRaResultDesc.addGestureRecognizer(DRaResultDescTap)
        
        // DRaStatusDesc
        self.scrollView.addSubview(self.DRaStatusDesc)
        self.DRaStatusDesc.translatesAutoresizingMaskIntoConstraints = false
        self.DRaStatusDesc.topAnchor.constraint(equalTo: self.DRaResultDesc.topAnchor, constant: 0).isActive = true
        self.DRaStatusDesc.rightAnchor.constraint(equalTo: self.DRaResultDesc.leftAnchor, constant: -10).isActive = true
        self.DRaStatusDesc.font = UIFont(name: Constants.iconFont.fontAwesome.rawValue, size: Constants.iconSize.xsmall.rawValue)
        
        // SOrResultDesc
        self.scrollView.addSubview(self.SOrResultDesc)
        self.SOrResultDesc.translatesAutoresizingMaskIntoConstraints = false
        self.SOrResultDesc.topAnchor.constraint(equalTo: self.DRaResultDesc.bottomAnchor, constant: self.lineSpacing).isActive = true
        self.SOrResultDesc.leftAnchor.constraint(equalTo: self.DRaResultDesc.leftAnchor).isActive = true
        self.SOrResultDesc.rightAnchor.constraint(equalTo: self.DRaResultDesc.rightAnchor).isActive = true
        self.SOrResultDesc.numberOfLines = 0
        self.SOrResultDesc.font = UIFont(name: Constants.appFont.regular.rawValue, size: Constants.fontSize.small.rawValue)
        self.SOrResultDescTap.addTarget(self, action: #selector(self.onClickLineItem))
        self.SOrResultDesc.isUserInteractionEnabled = true
        self.SOrResultDesc.addGestureRecognizer(SOrResultDescTap)
        
        // SOrStatusDesc
        self.scrollView.addSubview(self.SOrStatusDesc)
        self.SOrStatusDesc.translatesAutoresizingMaskIntoConstraints = false
        self.SOrStatusDesc.topAnchor.constraint(equalTo: self.SOrResultDesc.topAnchor, constant: 0).isActive = true
        self.SOrStatusDesc.rightAnchor.constraint(equalTo: self.SOrResultDesc.leftAnchor, constant: -10).isActive = true
        self.SOrStatusDesc.font = UIFont(name: Constants.iconFont.fontAwesome.rawValue, size: Constants.iconSize.xsmall.rawValue)
        
        // previousROIResultDesc
        self.scrollView.addSubview(self.previousROIResultDesc)
        self.previousROIResultDesc.translatesAutoresizingMaskIntoConstraints = false
        self.previousROIResultDesc.topAnchor.constraint(equalTo: self.SOrResultDesc.bottomAnchor, constant: self.lineSpacing).isActive = true
        self.previousROIResultDesc.leftAnchor.constraint(equalTo: self.SOrResultDesc.leftAnchor).isActive = true
        self.previousROIResultDesc.rightAnchor.constraint(equalTo: self.SOrResultDesc.rightAnchor).isActive = true
        self.previousROIResultDesc.numberOfLines = 0
        self.previousROIResultDesc.font = UIFont(name: Constants.appFont.regular.rawValue, size: Constants.fontSize.small.rawValue)
        self.previousROIResultDescTap.addTarget(self, action: #selector(self.onClickLineItem))
        self.previousROIResultDesc.isUserInteractionEnabled = true
        self.previousROIResultDesc.addGestureRecognizer(previousROIResultDescTap)
        
        // previousROIStatusDesc
        self.scrollView.addSubview(self.previousROIStatusDesc)
        self.previousROIStatusDesc.translatesAutoresizingMaskIntoConstraints = false
        self.previousROIStatusDesc.topAnchor.constraint(equalTo: self.previousROIResultDesc.topAnchor, constant: 0).isActive = true
        self.previousROIStatusDesc.rightAnchor.constraint(equalTo: self.previousROIResultDesc.leftAnchor, constant: -10).isActive = true
        self.previousROIStatusDesc.font = UIFont(name: Constants.iconFont.fontAwesome.rawValue, size: Constants.iconSize.xsmall.rawValue)
        
        // expectedROIResultDesc
        self.scrollView.addSubview(self.expectedROIResultDesc)
        self.expectedROIResultDesc.translatesAutoresizingMaskIntoConstraints = false
        self.expectedROIResultDesc.topAnchor.constraint(equalTo: self.previousROIResultDesc.bottomAnchor, constant: self.lineSpacing).isActive = true
        self.expectedROIResultDesc.leftAnchor.constraint(equalTo: self.previousROIResultDesc.leftAnchor).isActive = true
        self.expectedROIResultDesc.rightAnchor.constraint(equalTo: self.previousROIResultDesc.rightAnchor).isActive = true
        self.expectedROIResultDesc.numberOfLines = 0
        self.expectedROIResultDesc.font = UIFont(name: Constants.appFont.regular.rawValue, size: Constants.fontSize.small.rawValue)
        self.expectedROIResultDescTap.addTarget(self, action: #selector(self.onClickLineItem))
        self.expectedROIResultDesc.isUserInteractionEnabled = true
        self.expectedROIResultDesc.addGestureRecognizer(expectedROIResultDescTap)
        self.expectedROIResultDesc.accessibilityLabel = "expectedROIResultDesc"
        
        // expectedROIStatusDesc
        self.scrollView.addSubview(self.expectedROIStatusDesc)
        self.expectedROIStatusDesc.translatesAutoresizingMaskIntoConstraints = false
        self.expectedROIStatusDesc.topAnchor.constraint(equalTo: self.expectedROIResultDesc.topAnchor, constant: 0).isActive = true
        self.expectedROIStatusDesc.rightAnchor.constraint(equalTo: self.expectedROIResultDesc.leftAnchor, constant: -10).isActive = true
        self.expectedROIStatusDesc.font = UIFont(name: Constants.iconFont.fontAwesome.rawValue, size: Constants.iconSize.xsmall.rawValue)
        
        // q1Desc
        self.scrollView.addSubview(self.q1Desc)
        self.q1Desc.translatesAutoresizingMaskIntoConstraints = false
        self.q1Desc.topAnchor.constraint(equalTo: self.expectedROIResultDesc.bottomAnchor, constant: self.lineSpacing).isActive = true
        self.q1Desc.leftAnchor.constraint(equalTo: self.expectedROIResultDesc.leftAnchor).isActive = true
        self.q1Desc.rightAnchor.constraint(equalTo: self.expectedROIResultDesc.rightAnchor).isActive = true
        self.q1Desc.numberOfLines = 0
        self.q1Desc.font = UIFont(name: Constants.appFont.regular.rawValue, size: Constants.fontSize.small.rawValue)
        self.q1DescTap.addTarget(self, action: #selector(self.onClickLineItem))
        self.q1Desc.isUserInteractionEnabled = true
        self.q1Desc.addGestureRecognizer(q1DescTap)
        
        // q1StatusDesc
        self.scrollView.addSubview(self.q1StatusDesc)
        self.q1StatusDesc.translatesAutoresizingMaskIntoConstraints = false
        self.q1StatusDesc.topAnchor.constraint(equalTo: self.q1Desc.topAnchor, constant: 0).isActive = true
        self.q1StatusDesc.rightAnchor.constraint(equalTo: self.q1Desc.leftAnchor, constant: -10).isActive = true
        self.q1StatusDesc.font = UIFont(name: Constants.iconFont.fontAwesome.rawValue, size: Constants.iconSize.xsmall.rawValue)
        
        // q2Desc
        self.scrollView.addSubview(self.q2Desc)
        self.q2Desc.translatesAutoresizingMaskIntoConstraints = false
        self.q2Desc.topAnchor.constraint(equalTo: self.q1Desc.bottomAnchor, constant: self.lineSpacing).isActive = true
        self.q2Desc.leftAnchor.constraint(equalTo: self.q1Desc.leftAnchor).isActive = true
        self.q2Desc.rightAnchor.constraint(equalTo: self.q1Desc.rightAnchor).isActive = true
        self.q2Desc.numberOfLines = 0
        self.q2Desc.font = UIFont(name: Constants.appFont.regular.rawValue, size: Constants.fontSize.small.rawValue)
        self.q2DescTap.addTarget(self, action: #selector(self.onClickLineItem))
        self.q2Desc.isUserInteractionEnabled = true
        self.q2Desc.addGestureRecognizer(q2DescTap)
        
        // q2StatusDesc
        self.scrollView.addSubview(self.q2StatusDesc)
        self.q2StatusDesc.translatesAutoresizingMaskIntoConstraints = false
        self.q2StatusDesc.topAnchor.constraint(equalTo: self.q2Desc.topAnchor, constant: 0).isActive = true
        self.q2StatusDesc.rightAnchor.constraint(equalTo: self.q2Desc.leftAnchor, constant: -10).isActive = true
        self.q2StatusDesc.font = UIFont(name: Constants.iconFont.fontAwesome.rawValue, size: Constants.iconSize.xsmall.rawValue)
        
        // q3Desc
        self.scrollView.addSubview(self.q3Desc)
        self.q3Desc.translatesAutoresizingMaskIntoConstraints = false
        self.q3Desc.topAnchor.constraint(equalTo: self.q2Desc.bottomAnchor, constant: self.lineSpacing).isActive = true
        self.q3Desc.leftAnchor.constraint(equalTo: self.q2Desc.leftAnchor).isActive = true
        self.q3Desc.rightAnchor.constraint(equalTo: self.q2Desc.rightAnchor).isActive = true
        self.q3Desc.numberOfLines = 0
        self.q3Desc.font = UIFont(name: Constants.appFont.regular.rawValue, size: Constants.fontSize.small.rawValue)
        self.q3DescTap.addTarget(self, action: #selector(self.onClickLineItem))
        self.q3Desc.isUserInteractionEnabled = true
        self.q3Desc.addGestureRecognizer(q3DescTap)
        
        // q3StatusDesc
        self.scrollView.addSubview(self.q3StatusDesc)
        self.q3StatusDesc.translatesAutoresizingMaskIntoConstraints = false
        self.q3StatusDesc.topAnchor.constraint(equalTo: self.q3Desc.topAnchor, constant: 0).isActive = true
        self.q3StatusDesc.rightAnchor.constraint(equalTo: self.q3Desc.leftAnchor, constant: -10).isActive = true
        self.q3StatusDesc.font = UIFont(name: Constants.iconFont.fontAwesome.rawValue, size: Constants.iconSize.xsmall.rawValue)
        
        // q4Desc
        self.scrollView.addSubview(self.q4Desc)
        self.q4Desc.translatesAutoresizingMaskIntoConstraints = false
        self.q4Desc.topAnchor.constraint(equalTo: self.q3Desc.bottomAnchor, constant: self.lineSpacing).isActive = true
        self.q4Desc.leftAnchor.constraint(equalTo: self.q3Desc.leftAnchor).isActive = true
        self.q4Desc.rightAnchor.constraint(equalTo: self.q3Desc.rightAnchor).isActive = true
        self.q4Desc.numberOfLines = 0
        self.q4Desc.font = UIFont(name: Constants.appFont.regular.rawValue, size: Constants.fontSize.small.rawValue)
        self.q4DescTap.addTarget(self, action: #selector(self.onClickLineItem))
        self.q4Desc.isUserInteractionEnabled = true
        self.q4Desc.addGestureRecognizer(q4DescTap)
        
        // q4StatusDesc
        self.scrollView.addSubview(self.q4StatusDesc)
        self.q4StatusDesc.translatesAutoresizingMaskIntoConstraints = false
        self.q4StatusDesc.topAnchor.constraint(equalTo: self.q4Desc.topAnchor, constant: 0).isActive = true
        self.q4StatusDesc.rightAnchor.constraint(equalTo: self.q4Desc.leftAnchor, constant: -10).isActive = true
        self.q4StatusDesc.font = UIFont(name: Constants.iconFont.fontAwesome.rawValue, size: Constants.iconSize.xsmall.rawValue)
        
        // q5Desc
        self.scrollView.addSubview(self.q5Desc)
        self.q5Desc.translatesAutoresizingMaskIntoConstraints = false
        self.q5Desc.topAnchor.constraint(equalTo: self.q4Desc.bottomAnchor, constant: self.lineSpacing).isActive = true
        self.q5Desc.leftAnchor.constraint(equalTo: self.q4Desc.leftAnchor).isActive = true
        self.q5Desc.rightAnchor.constraint(equalTo: self.q4Desc.rightAnchor).isActive = true
        self.q5Desc.numberOfLines = 0
        self.q5Desc.font = UIFont(name: Constants.appFont.regular.rawValue, size: Constants.fontSize.small.rawValue)
        self.q5DescTap.addTarget(self, action: #selector(self.onClickLineItem))
        self.q5Desc.isUserInteractionEnabled = true
        self.q5Desc.addGestureRecognizer(q5DescTap)
        
        // q5StatusDesc
        self.scrollView.addSubview(self.q5StatusDesc)
        self.q5StatusDesc.translatesAutoresizingMaskIntoConstraints = false
        self.q5StatusDesc.topAnchor.constraint(equalTo: self.q5Desc.topAnchor, constant: 0).isActive = true
        self.q5StatusDesc.rightAnchor.constraint(equalTo: self.q5Desc.leftAnchor, constant: -10).isActive = true
        self.q5StatusDesc.font = UIFont(name: Constants.iconFont.fontAwesome.rawValue, size: Constants.iconSize.xsmall.rawValue)
        
        // q6Desc
        self.scrollView.addSubview(self.q6Desc)
        self.q6Desc.translatesAutoresizingMaskIntoConstraints = false
        self.q6Desc.topAnchor.constraint(equalTo: self.q5Desc.bottomAnchor, constant: self.lineSpacing).isActive = true
        self.q6Desc.leftAnchor.constraint(equalTo: self.q5Desc.leftAnchor).isActive = true
        self.q6Desc.rightAnchor.constraint(equalTo: self.q5Desc.rightAnchor).isActive = true
        self.q6Desc.numberOfLines = 0
        self.q6Desc.font = UIFont(name: Constants.appFont.regular.rawValue, size: Constants.fontSize.small.rawValue)
        self.q6DescTap.addTarget(self, action: #selector(self.onClickLineItem))
        self.q6Desc.isUserInteractionEnabled = true
        self.q6Desc.addGestureRecognizer(q6DescTap)
        
        // q6StatusDesc
        self.scrollView.addSubview(self.q6StatusDesc)
        self.q6StatusDesc.translatesAutoresizingMaskIntoConstraints = false
        self.q6StatusDesc.topAnchor.constraint(equalTo: self.q6Desc.topAnchor, constant: 0).isActive = true
        self.q6StatusDesc.rightAnchor.constraint(equalTo: self.q6Desc.leftAnchor, constant: -10).isActive = true
        self.q6StatusDesc.font = UIFont(name: Constants.iconFont.fontAwesome.rawValue, size: Constants.iconSize.xsmall.rawValue)
    }
    
    func onClickLineItem(sender: UILabel){
        if let measureTicker = sender.accessibilityLabel {
            self.delegate?.openMeasureDetail(measureTicker)
        }
    }
}
