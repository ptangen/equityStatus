//
//  ViewController.swift
//  EquityStatus
//
//  Created by Paul Tangen on 12/18/16.
//  Copyright © 2016 Paul Tangen. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, LoginViewDelegate {
    
    var loginViewInst: LoginView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.layoutAnimation()
        self.loginViewInst.delegate = self
    }
    
    override func loadView(){
        // hide nav bar on login page
        self.navigationController?.setNavigationBarHidden(true, animated: .init(true))
        
        // load the view into the view controller
        self.loginViewInst = LoginView(frame: CGRect.zero)
        self.view = self.loginViewInst
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showNoReplyMessage() {
        let alertController = UIAlertController(title: "Error", message: "Unable to connect with the Equity Status server. Please report this issue to ptangen@ptangen.com", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func openBuy() {
        let buyViewControllerInst = BuyViewController()
        navigationController?.pushViewController(buyViewControllerInst, animated: true) // show destination with nav bar
    }
    
    func layoutAnimation() {
        // kick off animation in the view
        UIView.animate(withDuration: 0.7) {
            self.loginViewInst.welcomeLabelYConstraintStart.isActive = false
            self.loginViewInst.welcomeLabelYConstraintEnd.isActive = true
            
            self.loginViewInst.bullImageYConstraintStart.isActive = false
            self.loginViewInst.bullImageYConstraintEnd.isActive = true
            self.loginViewInst.bullImageWidthConstraintStart.isActive = false
            self.loginViewInst.bullImageWidthConstraintEnd.isActive = true
            self.loginViewInst.bullImageLeadingConstraintStart.isActive = false
            self.loginViewInst.bullImageLeadingConstraintEnd.isActive = true
            self.loginViewInst.bullImageHeightConstraintStart.isActive = false
            self.loginViewInst.bullImageHeightConstraintEnd.isActive = true
            
            self.loginViewInst.userNameFieldLeftConstraintStart.isActive = false
            self.loginViewInst.userNameFieldLeftConstraintEnd.isActive = true
            self.loginViewInst.userNameFieldWidthConstraintStart.isActive = false
            self.loginViewInst.userNameFieldWidthConstraintEnd.isActive = true
            
            self.loginViewInst.layoutIfNeeded()
        }
    }
    
}

