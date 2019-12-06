//
//  DataCollectionTableViewCell.swift
//  EquityStatus
//
//  Created by Paul Tangen on 11/16/19.
//  Copyright © 2019 Paul Tangen. All rights reserved.
//

import UIKit

class DataCollectionTableViewCell: UITableViewCell {
    
    let nameLabel = UILabel()
    let eps_iLabel = UILabel()
    let eps_sdLabel = UILabel()
    let roe_avgLabel = UILabel()
    let bv_iLabel = UILabel()
    let dr_avgLabel = UILabel()
    let so_reducedLabel = UILabel()
    var previous_roiLabel = UILabel()
    var expected_roiLabel = UILabel()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //text label - ticker
        textLabel?.translatesAutoresizingMaskIntoConstraints = false
        textLabel?.numberOfLines = 0
        textLabel?.font = UIFont(name: Constants.appFont.regular.rawValue, size: CGFloat(Constants.fontSize.small.rawValue))
        textLabel?.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -6).isActive = true
        textLabel?.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        textLabel?.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        // expected_roiLabel
        contentView.addSubview(expected_roiLabel)
        expected_roiLabel.translatesAutoresizingMaskIntoConstraints = false
        expected_roiLabel.font = UIFont(name: Constants.appFont.regular.rawValue, size: CGFloat(Constants.fontSize.small.rawValue))
        expected_roiLabel.textAlignment = .right;
        expected_roiLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16).isActive = true
        expected_roiLabel.widthAnchor.constraint(equalToConstant: 30).isActive = true
        expected_roiLabel.bottomAnchor.constraint(equalTo: self.textLabel!.bottomAnchor, constant: 0).isActive = true
        
        // previous_roiLabel
        contentView.addSubview(previous_roiLabel)
        previous_roiLabel.translatesAutoresizingMaskIntoConstraints = false
        previous_roiLabel.font = UIFont(name: Constants.appFont.regular.rawValue, size: CGFloat(Constants.fontSize.small.rawValue))
        previous_roiLabel.textAlignment = .right;
        previous_roiLabel.rightAnchor.constraint(equalTo: self.expected_roiLabel.leftAnchor, constant: -30).isActive = true
        previous_roiLabel.bottomAnchor.constraint(equalTo: self.textLabel!.bottomAnchor, constant: 0).isActive = true
        
        // nameLabel
        contentView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont(name: Constants.appFont.regular.rawValue, size: CGFloat(Constants.fontSize.small.rawValue))
        nameLabel.leftAnchor.constraint(equalTo: self.textLabel!.rightAnchor, constant: 20).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: self.previous_roiLabel.leftAnchor, constant: -10).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: self.textLabel!.bottomAnchor, constant: 0).isActive = true

        // eps_iLabel
        contentView.addSubview(eps_iLabel)
        eps_iLabel.translatesAutoresizingMaskIntoConstraints = false
        eps_iLabel.font = UIFont(name: Constants.appFont.regular.rawValue, size: CGFloat(Constants.fontSize.xxsmall.rawValue))
        eps_iLabel.textColor = UIColor.gray
        eps_iLabel.leftAnchor.constraint(equalTo: self.nameLabel.leftAnchor, constant: 0).isActive = true
        eps_iLabel.topAnchor.constraint(equalTo: self.textLabel!.bottomAnchor, constant: 2).isActive = true

        // eps_sdLabel
        contentView.addSubview(eps_sdLabel)
        eps_sdLabel.translatesAutoresizingMaskIntoConstraints = false
        eps_sdLabel.font = UIFont(name: Constants.appFont.regular.rawValue, size: CGFloat(Constants.fontSize.xxsmall.rawValue))
        eps_sdLabel.textColor = UIColor.gray
        eps_sdLabel.leftAnchor.constraint(equalTo: self.eps_iLabel.leftAnchor, constant: 0).isActive = true
        eps_sdLabel.topAnchor.constraint(equalTo: self.eps_iLabel.bottomAnchor, constant: 2).isActive = true

        // roe_avgLabel
        contentView.addSubview(roe_avgLabel)
        roe_avgLabel.translatesAutoresizingMaskIntoConstraints = false
        roe_avgLabel.font = UIFont(name: Constants.appFont.regular.rawValue, size: CGFloat(Constants.fontSize.xxsmall.rawValue))
        roe_avgLabel.textColor = UIColor.gray
        roe_avgLabel.leftAnchor.constraint(equalTo: self.textLabel!.leftAnchor, constant: 150).isActive = true
        roe_avgLabel.topAnchor.constraint(equalTo: self.eps_iLabel.topAnchor).isActive = true
        
        // dr_avgLabel
        contentView.addSubview(dr_avgLabel)
        dr_avgLabel.translatesAutoresizingMaskIntoConstraints = false
        dr_avgLabel.font = UIFont(name: Constants.appFont.regular.rawValue, size: CGFloat(Constants.fontSize.xxsmall.rawValue))
        dr_avgLabel.textColor = UIColor.gray
        dr_avgLabel.leftAnchor.constraint(equalTo: self.roe_avgLabel.leftAnchor, constant: 0).isActive = true
        dr_avgLabel.topAnchor.constraint(equalTo: self.eps_sdLabel.topAnchor).isActive = true
        
        // bv_iLabel
        contentView.addSubview(bv_iLabel)
        bv_iLabel.translatesAutoresizingMaskIntoConstraints = false
        bv_iLabel.font = UIFont(name: Constants.appFont.regular.rawValue, size: CGFloat(Constants.fontSize.xxsmall.rawValue))
        bv_iLabel.textColor = UIColor.gray
        bv_iLabel.leftAnchor.constraint(equalTo: self.textLabel!.leftAnchor, constant: 240).isActive = true
        bv_iLabel.topAnchor.constraint(equalTo: self.eps_iLabel.topAnchor).isActive = true
        
        // so_reducedLabel
        contentView.addSubview(so_reducedLabel)
        so_reducedLabel.translatesAutoresizingMaskIntoConstraints = false
        so_reducedLabel.font = UIFont(name: Constants.appFont.regular.rawValue, size: CGFloat(Constants.fontSize.xxsmall.rawValue))
        so_reducedLabel.textColor = UIColor.gray
        so_reducedLabel.leftAnchor.constraint(equalTo: self.bv_iLabel.leftAnchor, constant: 0).isActive = true
        so_reducedLabel.topAnchor.constraint(equalTo: self.dr_avgLabel.topAnchor).isActive = true

    }
}

