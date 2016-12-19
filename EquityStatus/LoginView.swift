//
//  LoginView.swift
//  EquityStatus
//
//  Created by Paul Tangen on 12/18/16.
//  Copyright © 2016 Paul Tangen. All rights reserved.
//

import UIKit

class LoginView: UIView {

    let welcomeLabel: UILabel = UILabel()
    let equityStatusLabel: UILabel = UILabel()
    let userNameField: UITextField = UITextField()
    let passwordField: UITextField = UITextField()
    let signInButton: UIButton = UIButton()
    
    var bullImage: UIImageView = UIImageView(frame: CGRect(x: -640, y: 170, width: 1586, height: 510))
    
    var welcomeLabelYConstraintStart: NSLayoutConstraint!
    var welcomeLabelYConstraintEnd: NSLayoutConstraint!
    var bullImageYConstraintStart: NSLayoutConstraint!
    var bullImageYConstraintEnd: NSLayoutConstraint!
    var bullImageWidthConstraintStart: NSLayoutConstraint!
    var bullImageWidthConstraintEnd: NSLayoutConstraint!
    var bullImageHeightConstraintStart: NSLayoutConstraint!
    var bullImageHeightConstraintEnd: NSLayoutConstraint!
    var bullImageLeadingConstraintStart: NSLayoutConstraint!
    var bullImageLeadingConstraintEnd: NSLayoutConstraint!
    
    var userNameFieldLeftConstraintStart: NSLayoutConstraint!
    var userNameFieldLeftConstraintEnd: NSLayoutConstraint!
    var userNameFieldWidthConstraintStart: NSLayoutConstraint!
    var userNameFieldWidthConstraintEnd: NSLayoutConstraint!
    
    override init(frame:CGRect){
        super.init(frame: frame)
        layoutForm()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func layoutForm(){
        self.backgroundColor = UIColor(named: .gold)
        
        // welcome label
        self.welcomeLabel.text = "Welcome to"
        self.welcomeLabel.textAlignment = .center
        self.addSubview(self.welcomeLabel)
        self.welcomeLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.welcomeLabel.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        self.welcomeLabelYConstraintStart = self.welcomeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 360)
        self.welcomeLabelYConstraintEnd = self.welcomeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 100)
        self.welcomeLabelYConstraintStart.isActive = true
        self.welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // equity status label
        self.equityStatusLabel.text = "Equity Status"
        self.equityStatusLabel.textAlignment = .center
        self.equityStatusLabel.font = UIFont(name: Constants.appFont.bold.rawValue, size: Constants.fontSize.xlarge.rawValue)
        self.addSubview(self.equityStatusLabel)
        self.equityStatusLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.equityStatusLabel.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        self.equityStatusLabel.topAnchor.constraint(equalTo: self.welcomeLabel.bottomAnchor, constant: 10).isActive = true
        self.equityStatusLabel.translatesAutoresizingMaskIntoConstraints = false

        // bull image
        self.bullImage.image = UIImage(named: "bull+bear.png")
        self.addSubview(self.bullImage)
        self.bullImageLeadingConstraintStart = self.bullImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: -640)
        self.bullImageLeadingConstraintStart.isActive = true
        self.bullImageLeadingConstraintEnd = self.bullImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: -220)
        self.bullImageLeadingConstraintEnd.isActive = false
        self.bullImageWidthConstraintStart = self.bullImage.widthAnchor.constraint(equalToConstant: 1586)
        self.bullImageWidthConstraintStart.isActive = true
        self.bullImageWidthConstraintEnd = self.bullImage.widthAnchor.constraint(equalToConstant: 793)
        self.bullImageWidthConstraintEnd.isActive = false
        
        self.bullImageHeightConstraintStart = self.bullImage.heightAnchor.constraint(equalToConstant: 510)
        self.bullImageHeightConstraintStart.isActive = true
        self.bullImageHeightConstraintEnd = self.bullImage.heightAnchor.constraint(equalToConstant: 255)
        self.bullImageHeightConstraintEnd.isActive = false

        self.bullImageYConstraintStart = self.bullImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 170)
        self.bullImageYConstraintEnd = self.bullImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 400)
        self.bullImageYConstraintStart.isActive = true
        self.bullImageYConstraintEnd.isActive = false
        self.bullImage.translatesAutoresizingMaskIntoConstraints = false

        // userName Field
        self.addSubview(self.userNameField)
        self.userNameField.backgroundColor = UIColor.white
        self.userNameField.placeholder = "user name"
        self.userNameField.borderStyle = .bezel
        self.userNameField.topAnchor.constraint(equalTo: self.centerYAnchor, constant: -110).isActive = true
        
        self.userNameFieldLeftConstraintStart = self.userNameField.leftAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
        self.userNameFieldLeftConstraintStart.isActive = true
        self.userNameFieldLeftConstraintEnd = self.userNameField.leftAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
        self.userNameFieldLeftConstraintEnd.isActive = false
        
        self.userNameFieldWidthConstraintStart = self.userNameField.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.4)
        self.userNameFieldWidthConstraintStart.isActive = true
        self.userNameFieldWidthConstraintEnd = self.userNameField.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.4)
        self.userNameFieldWidthConstraintEnd.isActive = false

        self.userNameField.translatesAutoresizingMaskIntoConstraints = false

        // passwordField Field
        self.addSubview(self.passwordField)
        self.passwordField.backgroundColor = UIColor.white
        self.passwordField.borderStyle = .bezel
        self.passwordField.placeholder = "password"
        self.passwordField.widthAnchor.constraint(equalTo: self.userNameField.widthAnchor).isActive = true
        self.passwordField.leadingAnchor.constraint(equalTo: self.userNameField.leadingAnchor, constant: 0).isActive = true
        self.passwordField.topAnchor.constraint(equalTo: self.userNameField.bottomAnchor, constant: 25).isActive = true
        self.passwordField.translatesAutoresizingMaskIntoConstraints = false
        
        //self.signInButton.backgroundColor = UIColor(named: .blue)
        self.addSubview(self.signInButton)
        self.signInButton.setTitle("  Sign In  ", for: .normal)
        self.signInButton.backgroundColor = UIColor.blue
        self.signInButton.trailingAnchor.constraint(equalTo: self.passwordField.trailingAnchor, constant: 0).isActive = true
        self.signInButton.topAnchor.constraint(equalTo: self.passwordField.bottomAnchor, constant: 25).isActive = true
        self.signInButton.isEnabled = false
        self.signInButton.alpha = 0.3
        self.signInButton.translatesAutoresizingMaskIntoConstraints = false
        
        //self.layoutIfNeeded()
        
        UIView.animate(withDuration: 1.0) {
            self.welcomeLabelYConstraintStart.isActive = false
            self.welcomeLabelYConstraintEnd.isActive = true
            
            self.bullImageYConstraintStart.isActive = false
            self.bullImageYConstraintEnd.isActive = true
            self.bullImageWidthConstraintStart.isActive = false
            self.bullImageWidthConstraintEnd.isActive = true
            self.bullImageLeadingConstraintStart.isActive = false
            self.bullImageLeadingConstraintEnd.isActive = true
            self.bullImageHeightConstraintStart.isActive = false
            self.bullImageHeightConstraintEnd.isActive = true
            
//            self.userNameFieldLeftConstraintStart.isActive = false
//            self.userNameFieldLeftConstraintEnd.isActive = true
//            self.userNameFieldWidthConstraintStart.isActive = false
//            self.userNameFieldWidthConstraintEnd.isActive = true
            self.layoutIfNeeded()
        }
    }

}
