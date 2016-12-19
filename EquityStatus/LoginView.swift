//
//  LoginView.swift
//  EquityStatus
//
//  Created by Paul Tangen on 12/18/16.
//  Copyright © 2016 Paul Tangen. All rights reserved.
//

import UIKit

protocol LoginViewDelegate: class {
    func showNoReplyMessage()
    func openBuy()
}

class LoginView: UIView, UITextFieldDelegate {
    
    weak var delegate: LoginViewDelegate?

    // controls
    let welcomeLabel: UILabel = UILabel()
    let equityStatusLabel: UILabel = UILabel()
    let userNameField: UITextField = UITextField()
    let passwordField: UITextField = UITextField()
    let signInButton: UIButton = UIButton()
    var bullImage: UIImageView = UIImageView(frame: CGRect(x: -640, y: 170, width: 1586, height: 510))
    var userNamePopulated: Bool = false
    var passwordPopulated: Bool = false
    
    // constraints
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
        self.layoutForm()
        
        // add tag and set delegate for client side validation
        self.userNameField.tag = 100
        self.passwordField.tag = 101
        // set delegates
        self.userNameField.delegate = self
        self.passwordField.delegate = self
        
        self.signInButton.addTarget(self, action: #selector(LoginView.onClickSignIn), for: UIControlEvents.touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func onClickSignIn() {
        if let userName = self.userNameField.text {
            if let password = self.passwordField.text {
                
                apiClient.requestAuth(userName: userName, password: password, completion: { response in

                    switch response {
                        
                    case .authenticated:
                        self.delegate?.openBuy()
                        
                    case.userNameInvalid:
                        self.indicateError(fieldName: self.userNameField)
                        
                    case .passwordInvalid:
                        self.indicateError(fieldName: self.passwordField)

                    case.noReply:
                        self.delegate?.showNoReplyMessage()
                    }
                    
                })
                
            }
        }
    }
    
    func indicateError(fieldName textFieldWithError: UITextField){
        UIView.animate(withDuration: 1, animations: {
            textFieldWithError.backgroundColor = UIColor.red
            textFieldWithError.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }, completion: { success in
            UIView.animate(withDuration: 1, animations: {  // reset control to original state
                textFieldWithError.backgroundColor = UIColor.white
                textFieldWithError.transform = CGAffineTransform(scaleX: 1.0, y:1.0)
            })
        })
        self.signInButton.isEnabled = false
        self.signInButton.alpha = 0.3
    }
    
    
    // monitors the email/password fields and handles the client side validation
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField.tag {
        case 100:   // check to see if email has a value
            if self.userNameField.text!.utf16.count > 1 {
                self.userNamePopulated = true
            } else {
                self.userNamePopulated = false
            }
            self.enableDisableSignIn()
        case 101: // verify password > 1 characters  - the character count is odd, delete counts as a character...
            if self.passwordField.text!.utf16.count > 1 {
                self.passwordPopulated = true
            } else {
                self.passwordPopulated = false
            }
            self.enableDisableSignIn()
        default: break
        }
        return true
    }
    
    func enableDisableSignIn(){
        if self.userNamePopulated && self.passwordPopulated {
            self.signInButton.isEnabled = true
            self.signInButton.becomeFirstResponder()
            self.signInButton.alpha = 1.0
        } else {
            self.signInButton.isEnabled = false
            self.signInButton.alpha = 0.3
        }
    }

    func layoutForm(){
        self.backgroundColor = UIColor(named: .gold)
        
        // welcome label
        self.welcomeLabel.text = "Welcome to"
        self.welcomeLabel.textAlignment = .center
        self.addSubview(self.welcomeLabel)
        
        self.welcomeLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.welcomeLabel.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        
        self.welcomeLabelYConstraintStart = self.welcomeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: -150)
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
        self.userNameField.autocorrectionType = .no
        self.userNameField.autocapitalizationType = .none
        
        self.userNameFieldLeftConstraintStart = self.userNameField.leftAnchor.constraint(equalTo: self.centerXAnchor, constant: 150)
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
        self.passwordField.isSecureTextEntry = true
        
        self.passwordField.widthAnchor.constraint(equalTo: self.userNameField.widthAnchor).isActive = true
        self.passwordField.leadingAnchor.constraint(equalTo: self.userNameField.leadingAnchor, constant: 0).isActive = true
        self.passwordField.topAnchor.constraint(equalTo: self.userNameField.bottomAnchor, constant: 25).isActive = true
        
        self.passwordField.translatesAutoresizingMaskIntoConstraints = false
        
        // sign in button
        self.signInButton.backgroundColor = UIColor(named: .blue)
        self.addSubview(self.signInButton)
        self.signInButton.setTitle("  Sign In  ", for: .normal)
        self.signInButton.backgroundColor = UIColor.blue
        self.signInButton.isEnabled = false
        self.signInButton.alpha = 0.3
        
        self.signInButton.trailingAnchor.constraint(equalTo: self.passwordField.trailingAnchor, constant: 0).isActive = true
        self.signInButton.topAnchor.constraint(equalTo: self.passwordField.bottomAnchor, constant: 25).isActive = true

        self.signInButton.translatesAutoresizingMaskIntoConstraints = false
        
        // all
        self.layoutIfNeeded()
    }

}
