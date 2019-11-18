//
//  CompaniesTableViewCell.swift
//  EquityStatus
//
//  Created by Paul Tangen on 11/16/19.
//  Copyright © 2019 Paul Tangen. All rights reserved.
//

import UIKit

class CompaniesTableViewCell: UITableViewCell {
    
    var statusIcons = [UILabel]()
    let nameLabel:UILabel = UILabel()
    let monthLabel:UILabel = UILabel()

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
        textLabel?.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        // name label
        contentView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont(name: Constants.appFont.regular.rawValue, size: CGFloat(Constants.fontSize.small.rawValue))
        
        nameLabel.leftAnchor.constraint(equalTo: self.textLabel!.rightAnchor, constant: 20).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -80).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: self.textLabel!.bottomAnchor, constant: 0).isActive = true

        // month label
        contentView.addSubview(monthLabel)
        monthLabel.translatesAutoresizingMaskIntoConstraints = false
        monthLabel.font = UIFont(name: Constants.appFont.regular.rawValue, size: CGFloat(Constants.fontSize.small.rawValue))
        
        monthLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        monthLabel.bottomAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: 0).isActive = true

    }
}

