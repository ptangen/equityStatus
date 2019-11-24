//
//  tableViewCell.swift
//  EquityStatus
//
//  Created by Paul Tangen on 11/16/19.
//  Copyright © 2019 Paul Tangen. All rights reserved.
//

import UIKit

class tableViewCell: UITableViewCell {
    
    //var statusIcons = [UILabel]()
    let col2Label:UILabel = UILabel()
    let col3Label:UILabel = UILabel()
    let col4Label:UILabel = UILabel()

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
        
        // col4Label
        contentView.addSubview(col4Label)
        col4Label.translatesAutoresizingMaskIntoConstraints = false
        col4Label.font = UIFont(name: Constants.appFont.regular.rawValue, size: CGFloat(Constants.fontSize.small.rawValue))
        col4Label.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        col4Label.bottomAnchor.constraint(equalTo: self.textLabel!.bottomAnchor, constant: 0).isActive = true
        
        // col3Label
        contentView.addSubview(col3Label)
        col3Label.translatesAutoresizingMaskIntoConstraints = false
        col3Label.font = UIFont(name: Constants.appFont.regular.rawValue, size: CGFloat(Constants.fontSize.small.rawValue))
        col3Label.rightAnchor.constraint(equalTo: self.col4Label.rightAnchor, constant: -10).isActive = true
        col3Label.widthAnchor.constraint(equalToConstant: 120).isActive = true
        col3Label.bottomAnchor.constraint(equalTo: self.textLabel!.bottomAnchor, constant: 0).isActive = true
        
        // col2Label
        contentView.addSubview(col2Label)
        col2Label.translatesAutoresizingMaskIntoConstraints = false
        col2Label.font = UIFont(name: Constants.appFont.regular.rawValue, size: CGFloat(Constants.fontSize.small.rawValue))
        col2Label.leftAnchor.constraint(equalTo: self.textLabel!.rightAnchor, constant: 20).isActive = true
        col2Label.rightAnchor.constraint(equalTo: self.col3Label.leftAnchor, constant: -10).isActive = true
        col2Label.bottomAnchor.constraint(equalTo: self.textLabel!.bottomAnchor, constant: 0).isActive = true

    }
}

