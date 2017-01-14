//
//  EvaluationTableViewCell.swift
//  EquityStatus
//
//  Created by Paul Tangen on 12/26/16.
//  Copyright © 2016 Paul Tangen. All rights reserved.
//

import UIKit

class EvaluationTableViewCell: UITableViewCell {
    
    var measureIconText = [String]()
    var statusIcons = [UILabel]()
    let measureCount:Int = 14

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // status icons
        let spacer = (UIScreen.main.bounds.width - 20) / CGFloat(measureCount)
        let leftMargin: CGFloat = 10

        for i in 0 ... measureCount - 1 {
            let measureIcon:UILabel = UILabel()
            contentView.addSubview(measureIcon)
            measureIcon.translatesAutoresizingMaskIntoConstraints = false
            measureIcon.font = UIFont(name: Constants.iconFont.fontAwesome.rawValue, size: CGFloat(Constants.iconSize.xsmall.rawValue))
            measureIcon.textColor = UIColor(named: UIColor.ColorName.statusGreen)

            let leftConstant: CGFloat = leftMargin + (CGFloat(i) * spacer)
            measureIcon.leftAnchor.constraint(equalTo: self.leftAnchor, constant: leftConstant).isActive = true
            measureIcon.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2).isActive = true
            
            statusIcons.append(measureIcon) // add the icons to an array so you can iterate through them and set the icon in cellForRowAt
        }
        
        //text label
        textLabel?.translatesAutoresizingMaskIntoConstraints = false
        textLabel?.numberOfLines = 0
        textLabel?.font = UIFont(name: Constants.appFont.regular.rawValue, size: CGFloat(Constants.fontSize.small.rawValue))
        
        textLabel?.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -24).isActive = true
        textLabel?.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        textLabel?.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -3).isActive = true
    }
}
