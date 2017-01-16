//
//  SellTableViewCell.swift
//  EquityStatus
//
//  Created by Paul Tangen on 12/27/16.
//  Copyright © 2016 Paul Tangen. All rights reserved.
//

import UIKit

class SellTableViewCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //text label
        textLabel?.translatesAutoresizingMaskIntoConstraints = false
        textLabel?.numberOfLines = 0
        textLabel?.font = UIFont(name: Constants.appFont.regular.rawValue, size: CGFloat(Constants.fontSize.small.rawValue))
        
        textLabel?.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        textLabel?.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        textLabel?.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -3).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
