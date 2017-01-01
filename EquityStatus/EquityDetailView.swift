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
    let lineSpacing: CGFloat = 14
    
    let ROEaResultDesc: UILabel = UILabel()
    let ROEaResultDescTap: UITapGestureRecognizer = UITapGestureRecognizer()
    let ROEaStatusDesc: UILabel = UILabel()
    
    let EPSiResultDesc: UILabel = UILabel()
    let EPSiResultDescTap: UITapGestureRecognizer = UITapGestureRecognizer()
    let EPSiStatusDesc: UILabel = UILabel()
    
    let EPSvResultDesc: UILabel = UILabel()
    let EPSvResultDescTap: UITapGestureRecognizer = UITapGestureRecognizer()
    let EPSvStatusDesc: UILabel = UILabel()
    
    let BViResultDesc: UILabel = UILabel()
    let BViResultDescTap: UITapGestureRecognizer = UITapGestureRecognizer()
    let BViStatusDesc: UILabel = UILabel()
    
    let DRaResultDesc: UILabel = UILabel()
    let DRaResultDescTap: UITapGestureRecognizer = UITapGestureRecognizer()
    let DRaStatusDesc: UILabel = UILabel()
    
    let SOrResultDesc: UILabel = UILabel()
    let SOrResultDescTap: UITapGestureRecognizer = UITapGestureRecognizer()
    let SOrStatusDesc: UILabel = UILabel()
    
    let previousROIResultDesc: UILabel = UILabel()
    let previousROIResultDescTap: UITapGestureRecognizer = UITapGestureRecognizer()
    let previousROIStatusDesc: UILabel = UILabel()
    
    let expectedROIResultDesc: UILabel = UILabel()
    let expectedROIResultDescTap: UITapGestureRecognizer = UITapGestureRecognizer()
    let expectedROIStatusDesc: UILabel = UILabel()
    
    let q1Desc: UILabel = UILabel()
    let q1DescTap: UITapGestureRecognizer = UITapGestureRecognizer()
    let q1StatusDesc: UILabel = UILabel()
    
    let q2Desc: UILabel = UILabel()
    let q2DescTap: UITapGestureRecognizer = UITapGestureRecognizer()
    let q2StatusDesc: UILabel = UILabel()
    
    let q3Desc: UILabel = UILabel()
    let q3DescTap: UITapGestureRecognizer = UITapGestureRecognizer()
    let q3StatusDesc: UILabel = UILabel()
    
    let q4Desc: UILabel = UILabel()
    let q4DescTap: UITapGestureRecognizer = UITapGestureRecognizer()
    let q4StatusDesc: UILabel = UILabel()
    
    let q5Desc: UILabel = UILabel()
    let q5DescTap: UITapGestureRecognizer = UITapGestureRecognizer()
    let q5StatusDesc: UILabel = UILabel()
    
    let q6Desc: UILabel = UILabel()
    let q6DescTap: UITapGestureRecognizer = UITapGestureRecognizer()
    let q6StatusDesc: UILabel = UILabel()
    
    override init(frame:CGRect){
        super.init(frame: frame)
        
        self.pageLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func pageLayout() {
        
        // ROEaResultsDesc
        self.addSubview(self.ROEaResultDesc)
        self.ROEaResultDesc.translatesAutoresizingMaskIntoConstraints = false
        self.ROEaResultDesc.topAnchor.constraint(equalTo: self.topAnchor, constant: 80).isActive = true
        self.ROEaResultDesc.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 40).isActive = true
        self.ROEaResultDesc.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        self.ROEaResultDesc.numberOfLines = 0
        self.ROEaResultDesc.font = UIFont(name: Constants.appFont.regular.rawValue, size: Constants.fontSize.xsmall.rawValue)
        self.ROEaResultDescTap.addTarget(self, action: #selector(self.onClickLineItem))
        self.ROEaResultDesc.isUserInteractionEnabled = true
        self.ROEaResultDesc.addGestureRecognizer(ROEaResultDescTap)
        
        // ROEaStatusDesc
        self.addSubview(self.ROEaStatusDesc)
        self.ROEaStatusDesc.translatesAutoresizingMaskIntoConstraints = false
        self.ROEaStatusDesc.topAnchor.constraint(equalTo: self.ROEaResultDesc.topAnchor, constant: 0).isActive = true
        self.ROEaStatusDesc.rightAnchor.constraint(equalTo: self.ROEaResultDesc.leftAnchor, constant: -10).isActive = true
        self.ROEaStatusDesc.font = UIFont(name: Constants.iconFont.fontAwesome.rawValue, size: Constants.fontSize.xsmall.rawValue)
        
        // EPSiResultsDesc
        self.addSubview(self.EPSiResultDesc)
        self.EPSiResultDesc.translatesAutoresizingMaskIntoConstraints = false
        self.EPSiResultDesc.topAnchor.constraint(equalTo: self.ROEaResultDesc.bottomAnchor, constant: self.lineSpacing).isActive = true
        self.EPSiResultDesc.leftAnchor.constraint(equalTo: self.ROEaResultDesc.leftAnchor).isActive = true
        self.EPSiResultDesc.rightAnchor.constraint(equalTo: self.ROEaResultDesc.rightAnchor).isActive = true
        self.EPSiResultDesc.numberOfLines = 0
        self.EPSiResultDesc.font = UIFont(name: Constants.appFont.regular.rawValue, size: Constants.fontSize.xsmall.rawValue)
        self.EPSiResultDescTap.addTarget(self, action: #selector(self.onClickLineItem))
        self.EPSiResultDesc.isUserInteractionEnabled = true
        self.EPSiResultDesc.addGestureRecognizer(EPSiResultDescTap)
        
        // EPSiStatusDesc
        self.addSubview(self.EPSiStatusDesc)
        self.EPSiStatusDesc.translatesAutoresizingMaskIntoConstraints = false
        self.EPSiStatusDesc.topAnchor.constraint(equalTo: self.EPSiResultDesc.topAnchor, constant: 0).isActive = true
        self.EPSiStatusDesc.rightAnchor.constraint(equalTo: self.EPSiResultDesc.leftAnchor, constant: -10).isActive = true
        self.EPSiStatusDesc.font = UIFont(name: Constants.iconFont.fontAwesome.rawValue, size: Constants.fontSize.xsmall.rawValue)
        
        // EPSvResultDesc
        self.addSubview(self.EPSvResultDesc)
        self.EPSvResultDesc.translatesAutoresizingMaskIntoConstraints = false
        self.EPSvResultDesc.topAnchor.constraint(equalTo: self.EPSiResultDesc.bottomAnchor, constant: self.lineSpacing).isActive = true
        self.EPSvResultDesc.leftAnchor.constraint(equalTo: self.EPSiResultDesc.leftAnchor).isActive = true
        self.EPSvResultDesc.rightAnchor.constraint(equalTo: self.EPSiResultDesc.rightAnchor).isActive = true
        self.EPSvResultDesc.numberOfLines = 0
        self.EPSvResultDesc.font = UIFont(name: Constants.appFont.regular.rawValue, size: Constants.fontSize.xsmall.rawValue)
        self.EPSvResultDescTap.addTarget(self, action: #selector(self.onClickLineItem))
        self.EPSvResultDesc.isUserInteractionEnabled = true
        self.EPSvResultDesc.addGestureRecognizer(EPSvResultDescTap)
        
        // EPSvStatusDesc
        self.addSubview(self.EPSvStatusDesc)
        self.EPSvStatusDesc.translatesAutoresizingMaskIntoConstraints = false
        self.EPSvStatusDesc.topAnchor.constraint(equalTo: self.EPSvResultDesc.topAnchor, constant: 0).isActive = true
        self.EPSvStatusDesc.rightAnchor.constraint(equalTo: self.EPSvResultDesc.leftAnchor, constant: -10).isActive = true
        self.EPSvStatusDesc.font = UIFont(name: Constants.iconFont.fontAwesome.rawValue, size: Constants.fontSize.xsmall.rawValue)
        
        // BViResultDesc
        self.addSubview(self.BViResultDesc)
        self.BViResultDesc.translatesAutoresizingMaskIntoConstraints = false
        self.BViResultDesc.topAnchor.constraint(equalTo: self.EPSvResultDesc.bottomAnchor, constant: self.lineSpacing).isActive = true
        self.BViResultDesc.leftAnchor.constraint(equalTo: self.EPSvResultDesc.leftAnchor).isActive = true
        self.BViResultDesc.rightAnchor.constraint(equalTo: self.EPSvResultDesc.rightAnchor).isActive = true
        self.BViResultDesc.numberOfLines = 0
        self.BViResultDesc.font = UIFont(name: Constants.appFont.regular.rawValue, size: Constants.fontSize.xsmall.rawValue)
        self.BViResultDescTap.addTarget(self, action: #selector(self.onClickLineItem))
        self.BViResultDesc.isUserInteractionEnabled = true
        self.BViResultDesc.addGestureRecognizer(BViResultDescTap)
        
        // BViStatusDesc
        self.addSubview(self.BViStatusDesc)
        self.BViStatusDesc.translatesAutoresizingMaskIntoConstraints = false
        self.BViStatusDesc.topAnchor.constraint(equalTo: self.BViResultDesc.topAnchor, constant: 0).isActive = true
        self.BViStatusDesc.rightAnchor.constraint(equalTo: self.BViResultDesc.leftAnchor, constant: -10).isActive = true
        self.BViStatusDesc.font = UIFont(name: Constants.iconFont.fontAwesome.rawValue, size: Constants.fontSize.xsmall.rawValue)
        
        // DRaResultDesc
        self.addSubview(self.DRaResultDesc)
        self.DRaResultDesc.translatesAutoresizingMaskIntoConstraints = false
        self.DRaResultDesc.topAnchor.constraint(equalTo: self.BViResultDesc.bottomAnchor, constant: self.lineSpacing).isActive = true
        self.DRaResultDesc.leftAnchor.constraint(equalTo: self.BViResultDesc.leftAnchor).isActive = true
        self.DRaResultDesc.rightAnchor.constraint(equalTo: self.BViResultDesc.rightAnchor).isActive = true
        self.DRaResultDesc.numberOfLines = 0
        self.DRaResultDesc.font = UIFont(name: Constants.appFont.regular.rawValue, size: Constants.fontSize.xsmall.rawValue)
        self.DRaResultDescTap.addTarget(self, action: #selector(self.onClickLineItem))
        self.DRaResultDesc.isUserInteractionEnabled = true
        self.DRaResultDesc.addGestureRecognizer(DRaResultDescTap)
        
        // DRaStatusDesc
        self.addSubview(self.DRaStatusDesc)
        self.DRaStatusDesc.translatesAutoresizingMaskIntoConstraints = false
        self.DRaStatusDesc.topAnchor.constraint(equalTo: self.DRaResultDesc.topAnchor, constant: 0).isActive = true
        self.DRaStatusDesc.rightAnchor.constraint(equalTo: self.DRaResultDesc.leftAnchor, constant: -10).isActive = true
        self.DRaStatusDesc.font = UIFont(name: Constants.iconFont.fontAwesome.rawValue, size: Constants.fontSize.xsmall.rawValue)
        
        // SOrResultDesc
        self.addSubview(self.SOrResultDesc)
        self.SOrResultDesc.translatesAutoresizingMaskIntoConstraints = false
        self.SOrResultDesc.topAnchor.constraint(equalTo: self.DRaResultDesc.bottomAnchor, constant: self.lineSpacing).isActive = true
        self.SOrResultDesc.leftAnchor.constraint(equalTo: self.DRaResultDesc.leftAnchor).isActive = true
        self.SOrResultDesc.rightAnchor.constraint(equalTo: self.DRaResultDesc.rightAnchor).isActive = true
        self.SOrResultDesc.numberOfLines = 0
        self.SOrResultDesc.font = UIFont(name: Constants.appFont.regular.rawValue, size: Constants.fontSize.xsmall.rawValue)
        self.SOrResultDescTap.addTarget(self, action: #selector(self.onClickLineItem))
        self.SOrResultDesc.isUserInteractionEnabled = true
        self.SOrResultDesc.addGestureRecognizer(SOrResultDescTap)
        
        // SOrStatusDesc
        self.addSubview(self.SOrStatusDesc)
        self.SOrStatusDesc.translatesAutoresizingMaskIntoConstraints = false
        self.SOrStatusDesc.topAnchor.constraint(equalTo: self.SOrResultDesc.topAnchor, constant: 0).isActive = true
        self.SOrStatusDesc.rightAnchor.constraint(equalTo: self.SOrResultDesc.leftAnchor, constant: -10).isActive = true
        self.SOrStatusDesc.font = UIFont(name: Constants.iconFont.fontAwesome.rawValue, size: Constants.fontSize.xsmall.rawValue)
        
        // previousROIResultDesc
        self.addSubview(self.previousROIResultDesc)
        self.previousROIResultDesc.translatesAutoresizingMaskIntoConstraints = false
        self.previousROIResultDesc.topAnchor.constraint(equalTo: self.SOrResultDesc.bottomAnchor, constant: self.lineSpacing).isActive = true
        self.previousROIResultDesc.leftAnchor.constraint(equalTo: self.SOrResultDesc.leftAnchor).isActive = true
        self.previousROIResultDesc.rightAnchor.constraint(equalTo: self.SOrResultDesc.rightAnchor).isActive = true
        self.previousROIResultDesc.numberOfLines = 0
        self.previousROIResultDesc.font = UIFont(name: Constants.appFont.regular.rawValue, size: Constants.fontSize.xsmall.rawValue)
        self.previousROIResultDescTap.addTarget(self, action: #selector(self.onClickLineItem))
        self.previousROIResultDesc.isUserInteractionEnabled = true
        self.previousROIResultDesc.addGestureRecognizer(previousROIResultDescTap)
        
        // previousROIStatusDesc
        self.addSubview(self.previousROIStatusDesc)
        self.previousROIStatusDesc.translatesAutoresizingMaskIntoConstraints = false
        self.previousROIStatusDesc.topAnchor.constraint(equalTo: self.previousROIResultDesc.topAnchor, constant: 0).isActive = true
        self.previousROIStatusDesc.rightAnchor.constraint(equalTo: self.previousROIResultDesc.leftAnchor, constant: -10).isActive = true
        self.previousROIStatusDesc.font = UIFont(name: Constants.iconFont.fontAwesome.rawValue, size: Constants.fontSize.xsmall.rawValue)
        
        // expectedROIResultDesc
        self.addSubview(self.expectedROIResultDesc)
        self.expectedROIResultDesc.translatesAutoresizingMaskIntoConstraints = false
        self.expectedROIResultDesc.topAnchor.constraint(equalTo: self.previousROIResultDesc.bottomAnchor, constant: self.lineSpacing).isActive = true
        self.expectedROIResultDesc.leftAnchor.constraint(equalTo: self.previousROIResultDesc.leftAnchor).isActive = true
        self.expectedROIResultDesc.rightAnchor.constraint(equalTo: self.previousROIResultDesc.rightAnchor).isActive = true
        self.expectedROIResultDesc.numberOfLines = 0
        self.expectedROIResultDesc.font = UIFont(name: Constants.appFont.regular.rawValue, size: Constants.fontSize.xsmall.rawValue)
        self.expectedROIResultDescTap.addTarget(self, action: #selector(self.onClickLineItem))
        self.expectedROIResultDesc.isUserInteractionEnabled = true
        self.expectedROIResultDesc.addGestureRecognizer(expectedROIResultDescTap)
        
        // expectedROIStatusDesc
        self.addSubview(self.expectedROIStatusDesc)
        self.expectedROIStatusDesc.translatesAutoresizingMaskIntoConstraints = false
        self.expectedROIStatusDesc.topAnchor.constraint(equalTo: self.expectedROIResultDesc.topAnchor, constant: 0).isActive = true
        self.expectedROIStatusDesc.rightAnchor.constraint(equalTo: self.expectedROIResultDesc.leftAnchor, constant: -10).isActive = true
        self.expectedROIStatusDesc.font = UIFont(name: Constants.iconFont.fontAwesome.rawValue, size: Constants.fontSize.xsmall.rawValue)
        
        // q1Desc
        self.addSubview(self.q1Desc)
        self.q1Desc.translatesAutoresizingMaskIntoConstraints = false
        self.q1Desc.topAnchor.constraint(equalTo: self.expectedROIResultDesc.bottomAnchor, constant: self.lineSpacing).isActive = true
        self.q1Desc.leftAnchor.constraint(equalTo: self.expectedROIResultDesc.leftAnchor).isActive = true
        self.q1Desc.rightAnchor.constraint(equalTo: self.expectedROIResultDesc.rightAnchor).isActive = true
        self.q1Desc.numberOfLines = 0
        self.q1Desc.font = UIFont(name: Constants.appFont.regular.rawValue, size: Constants.fontSize.xsmall.rawValue)
        self.q1DescTap.addTarget(self, action: #selector(self.onClickLineItem))
        self.q1Desc.isUserInteractionEnabled = true
        self.q1Desc.addGestureRecognizer(q1DescTap)
        
        // q1StatusDesc
        self.addSubview(self.q1StatusDesc)
        self.q1StatusDesc.translatesAutoresizingMaskIntoConstraints = false
        self.q1StatusDesc.topAnchor.constraint(equalTo: self.q1Desc.topAnchor, constant: 0).isActive = true
        self.q1StatusDesc.rightAnchor.constraint(equalTo: self.q1Desc.leftAnchor, constant: -10).isActive = true
        self.q1StatusDesc.font = UIFont(name: Constants.iconFont.fontAwesome.rawValue, size: Constants.fontSize.xsmall.rawValue)
        
        // q2Desc
        self.addSubview(self.q2Desc)
        self.q2Desc.translatesAutoresizingMaskIntoConstraints = false
        self.q2Desc.topAnchor.constraint(equalTo: self.q1Desc.bottomAnchor, constant: self.lineSpacing).isActive = true
        self.q2Desc.leftAnchor.constraint(equalTo: self.q1Desc.leftAnchor).isActive = true
        self.q2Desc.rightAnchor.constraint(equalTo: self.q1Desc.rightAnchor).isActive = true
        self.q2Desc.numberOfLines = 0
        self.q2Desc.font = UIFont(name: Constants.appFont.regular.rawValue, size: Constants.fontSize.xsmall.rawValue)
        self.q2DescTap.addTarget(self, action: #selector(self.onClickLineItem))
        self.q2Desc.isUserInteractionEnabled = true
        self.q2Desc.addGestureRecognizer(q2DescTap)
        
        // q2StatusDesc
        self.addSubview(self.q2StatusDesc)
        self.q2StatusDesc.translatesAutoresizingMaskIntoConstraints = false
        self.q2StatusDesc.topAnchor.constraint(equalTo: self.q2Desc.topAnchor, constant: 0).isActive = true
        self.q2StatusDesc.rightAnchor.constraint(equalTo: self.q2Desc.leftAnchor, constant: -10).isActive = true
        self.q2StatusDesc.font = UIFont(name: Constants.iconFont.fontAwesome.rawValue, size: Constants.fontSize.xsmall.rawValue)
        
        // q3Desc
        self.addSubview(self.q3Desc)
        self.q3Desc.translatesAutoresizingMaskIntoConstraints = false
        self.q3Desc.topAnchor.constraint(equalTo: self.q2Desc.bottomAnchor, constant: self.lineSpacing).isActive = true
        self.q3Desc.leftAnchor.constraint(equalTo: self.q2Desc.leftAnchor).isActive = true
        self.q3Desc.rightAnchor.constraint(equalTo: self.q2Desc.rightAnchor).isActive = true
        self.q3Desc.numberOfLines = 0
        self.q3Desc.font = UIFont(name: Constants.appFont.regular.rawValue, size: Constants.fontSize.xsmall.rawValue)
        self.q3DescTap.addTarget(self, action: #selector(self.onClickLineItem))
        self.q3Desc.isUserInteractionEnabled = true
        self.q3Desc.addGestureRecognizer(q3DescTap)
        
        // q3StatusDesc
        self.addSubview(self.q3StatusDesc)
        self.q3StatusDesc.translatesAutoresizingMaskIntoConstraints = false
        self.q3StatusDesc.topAnchor.constraint(equalTo: self.q3Desc.topAnchor, constant: 0).isActive = true
        self.q3StatusDesc.rightAnchor.constraint(equalTo: self.q3Desc.leftAnchor, constant: -10).isActive = true
        self.q3StatusDesc.font = UIFont(name: Constants.iconFont.fontAwesome.rawValue, size: Constants.fontSize.xsmall.rawValue)
        
        // q4Desc
        self.addSubview(self.q4Desc)
        self.q4Desc.translatesAutoresizingMaskIntoConstraints = false
        self.q4Desc.topAnchor.constraint(equalTo: self.q3Desc.bottomAnchor, constant: self.lineSpacing).isActive = true
        self.q4Desc.leftAnchor.constraint(equalTo: self.q3Desc.leftAnchor).isActive = true
        self.q4Desc.rightAnchor.constraint(equalTo: self.q3Desc.rightAnchor).isActive = true
        self.q4Desc.numberOfLines = 0
        self.q4Desc.font = UIFont(name: Constants.appFont.regular.rawValue, size: Constants.fontSize.xsmall.rawValue)
        self.q4DescTap.addTarget(self, action: #selector(self.onClickLineItem))
        self.q4Desc.isUserInteractionEnabled = true
        self.q4Desc.addGestureRecognizer(q4DescTap)
        
        // q4StatusDesc
        self.addSubview(self.q4StatusDesc)
        self.q4StatusDesc.translatesAutoresizingMaskIntoConstraints = false
        self.q4StatusDesc.topAnchor.constraint(equalTo: self.q4Desc.topAnchor, constant: 0).isActive = true
        self.q4StatusDesc.rightAnchor.constraint(equalTo: self.q4Desc.leftAnchor, constant: -10).isActive = true
        self.q4StatusDesc.font = UIFont(name: Constants.iconFont.fontAwesome.rawValue, size: Constants.fontSize.xsmall.rawValue)
        
        // q5Desc
        self.addSubview(self.q5Desc)
        self.q5Desc.translatesAutoresizingMaskIntoConstraints = false
        self.q5Desc.topAnchor.constraint(equalTo: self.q4Desc.bottomAnchor, constant: self.lineSpacing).isActive = true
        self.q5Desc.leftAnchor.constraint(equalTo: self.q4Desc.leftAnchor).isActive = true
        self.q5Desc.rightAnchor.constraint(equalTo: self.q4Desc.rightAnchor).isActive = true
        self.q5Desc.numberOfLines = 0
        self.q5Desc.font = UIFont(name: Constants.appFont.regular.rawValue, size: Constants.fontSize.xsmall.rawValue)
        self.q5DescTap.addTarget(self, action: #selector(self.onClickLineItem))
        self.q5Desc.isUserInteractionEnabled = true
        self.q5Desc.addGestureRecognizer(q5DescTap)
        
        // q5StatusDesc
        self.addSubview(self.q5StatusDesc)
        self.q5StatusDesc.translatesAutoresizingMaskIntoConstraints = false
        self.q5StatusDesc.topAnchor.constraint(equalTo: self.q5Desc.topAnchor, constant: 0).isActive = true
        self.q5StatusDesc.rightAnchor.constraint(equalTo: self.q5Desc.leftAnchor, constant: -10).isActive = true
        self.q5StatusDesc.font = UIFont(name: Constants.iconFont.fontAwesome.rawValue, size: Constants.fontSize.xsmall.rawValue)
        
        // q6Desc
        self.addSubview(self.q6Desc)
        self.q6Desc.translatesAutoresizingMaskIntoConstraints = false
        self.q6Desc.topAnchor.constraint(equalTo: self.q5Desc.bottomAnchor, constant: self.lineSpacing).isActive = true
        self.q6Desc.leftAnchor.constraint(equalTo: self.q5Desc.leftAnchor).isActive = true
        self.q6Desc.rightAnchor.constraint(equalTo: self.q5Desc.rightAnchor).isActive = true
        self.q6Desc.numberOfLines = 0
        self.q6Desc.font = UIFont(name: Constants.appFont.regular.rawValue, size: Constants.fontSize.xsmall.rawValue)
        self.q6DescTap.addTarget(self, action: #selector(self.onClickLineItem))
        self.q6Desc.isUserInteractionEnabled = true
        self.q6Desc.addGestureRecognizer(q6DescTap)
        
        // q6StatusDesc
        self.addSubview(self.q6StatusDesc)
        self.q6StatusDesc.translatesAutoresizingMaskIntoConstraints = false
        self.q6StatusDesc.topAnchor.constraint(equalTo: self.q6Desc.topAnchor, constant: 0).isActive = true
        self.q6StatusDesc.rightAnchor.constraint(equalTo: self.q6Desc.leftAnchor, constant: -10).isActive = true
        self.q6StatusDesc.font = UIFont(name: Constants.iconFont.fontAwesome.rawValue, size: Constants.fontSize.xsmall.rawValue)
    }
    
    func onClickLineItem(sender: UILabel){
        if let measureTicker = sender.accessibilityLabel {
            self.delegate?.openMeasureDetail(measureTicker)
        }
    }
}
