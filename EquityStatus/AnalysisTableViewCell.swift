//
//  AnalysisTableViewCell.swift
//  EquityStatus
//
//  Created by Paul Tangen on 12/26/16.
//  Copyright © 2016 Paul Tangen. All rights reserved.
//

import UIKit

class AnalysisTableViewCell: UITableViewCell {

    var measureIcon:UIImageView = UIImageView()
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // checkBox
        contentView.addSubview(measureIcon)
        
        measureIcon.translatesAutoresizingMaskIntoConstraints = false
        measureIcon.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4).isActive = true
        measureIcon.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        measureIcon.heightAnchor.constraint(equalToConstant: 16).isActive = true
        measureIcon.widthAnchor.constraint(equalToConstant: 16).isActive = true
        measureIcon.backgroundColor = UIColor.brown
        
        //text label
        textLabel?.translatesAutoresizingMaskIntoConstraints = false
        textLabel?.topAnchor.constraint(equalTo: self.topAnchor, constant: 4).isActive = true
        textLabel?.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        textLabel?.numberOfLines = 0
        textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        textLabel?.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -3).isActive = true
        
        textLabel?.adjustsFontSizeToFitWidth = true
    }

}
