//
//  AnalysisTableViewCell.swift
//  EquityStatus
//
//  Created by Paul Tangen on 12/26/16.
//  Copyright © 2016 Paul Tangen. All rights reserved.
//

import UIKit

class AnalysisTableViewCell: UITableViewCell {

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // status icons
        let spacer = (UIScreen.main.bounds.width - 20) / 13
        let leftMargin: CGFloat = 10

        for i in 0 ... 12 {
            let measureIcon:UILabel = UILabel()
            contentView.addSubview(measureIcon)
            measureIcon.translatesAutoresizingMaskIntoConstraints = false
            //measureIcon.text = Constants.iconLibrary.faCheckCircle.rawValue
            measureIcon.text = Constants.iconLibrary.faCircleO.rawValue
            measureIcon.font = UIFont(name: Constants.iconFont.fontAwesome.rawValue, size: CGFloat(Constants.iconSize.xsmall.rawValue))
            measureIcon.textColor = UIColor(named: UIColor.ColorName.esGreen)
            //measureIcon.textColor = UIColor(named: UIColor.ColorName.gold)

            let leftConstant: CGFloat = leftMargin + (CGFloat(i) * spacer)
            measureIcon.leftAnchor.constraint(equalTo: self.leftAnchor, constant: leftConstant).isActive = true
            measureIcon.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4).isActive = true
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
