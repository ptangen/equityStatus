//
//  WatchTableViewCell.swift
//  EquityStatus
//
//  Created by Paul Tangen on 11/11/23.
//  Copyright © 2023 Paul Tangen. All rights reserved.
//

import UIKit

class WatchTableViewCell: UITableViewCell {
    
    let previousROILabel = UILabel()
    let previousROIView = UIView()
    let expectedROILabel = UILabel()
    let expectedROIView = UIView()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //text label
        textLabel?.translatesAutoresizingMaskIntoConstraints = false
        textLabel?.numberOfLines = 0
        textLabel?.textAlignment = .right
        textLabel?.font = UIFont(name: Constants.appFont.regular.rawValue, size: CGFloat(Constants.fontSize.small.rawValue))
        
        textLabel?.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        textLabel?.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        textLabel?.rightAnchor.constraint(equalTo: self.centerXAnchor, constant: -20).isActive = true
        
        // previousROI View for bar chart
        contentView.addSubview(previousROIView)
        previousROIView.translatesAutoresizingMaskIntoConstraints = false
        previousROIView.backgroundColor = UIColor(named: .statusGreen)
        previousROIView.leftAnchor.constraint(equalTo: self.textLabel!.rightAnchor, constant: 10).isActive = true
        //previousROIView.widthAnchor set when defining cell content
        previousROIView.heightAnchor.constraint(equalToConstant: 26).isActive = true
        previousROIView.topAnchor.constraint(equalTo: self.textLabel!.topAnchor, constant: -18).isActive = true
        
        // previousROI Label
        previousROIView.addSubview(previousROILabel)
        previousROILabel.translatesAutoresizingMaskIntoConstraints = false
        previousROILabel.font = UIFont(name: Constants.appFont.regular.rawValue, size: CGFloat(Constants.fontSize.small.rawValue))
        previousROILabel.textAlignment = .left;
        previousROILabel.textColor = UIColor.white
        previousROILabel.leftAnchor.constraint(equalTo: self.previousROIView.leftAnchor, constant: 6).isActive = true
        previousROILabel.widthAnchor.constraint(equalToConstant: 48).isActive = true
        previousROILabel.topAnchor.constraint(equalTo: self.previousROIView.topAnchor, constant: 3).isActive = true
        
        // expected_roi View for bar chart
        contentView.addSubview(expectedROIView)
        expectedROIView.translatesAutoresizingMaskIntoConstraints = false
        expectedROIView.backgroundColor = UIColor(named: .lightGreen)
        expectedROIView.leftAnchor.constraint(equalTo: self.textLabel!.rightAnchor, constant: 10).isActive = true
        //expectedROIView.widthAnchor set when defining cell content
        expectedROIView.heightAnchor.constraint(equalToConstant: 26).isActive = true
        expectedROIView.topAnchor.constraint(equalTo: self.previousROIView.bottomAnchor, constant: 4).isActive = true
        
        // expected_roi Label
        expectedROIView.addSubview(expectedROILabel)
        expectedROILabel.translatesAutoresizingMaskIntoConstraints = false
        expectedROILabel.font = UIFont(name: Constants.appFont.regular.rawValue, size: CGFloat(Constants.fontSize.small.rawValue))
        expectedROILabel.textAlignment = .left;
        expectedROILabel.leftAnchor.constraint(equalTo: self.expectedROIView.leftAnchor, constant: 6).isActive = true
        expectedROILabel.widthAnchor.constraint(equalToConstant: 48).isActive = true
        expectedROILabel.topAnchor.constraint(equalTo: self.expectedROIView.topAnchor, constant: 3).isActive = true
    }
}
