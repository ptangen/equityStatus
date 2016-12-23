//
//  SignInViewController.swift
//  EquityStatus
//
//  Created by Paul Tangen on 12/18/16.
//  Copyright © 2016 Paul Tangen. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController, SignInViewDelegate {
    
    var signInViewInst: SignInView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.layoutAnimation()
        self.signInViewInst.delegate = self
    }
    
    override func loadView(){
        // hide nav bar on login page
        self.navigationController?.setNavigationBarHidden(true, animated: .init(true))
        
        // load the view into the view controller
        self.signInViewInst = SignInView(frame: CGRect.zero)
        self.view = self.signInViewInst
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAlertMessage(_ message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func openTabDisplay() {
        let tabViewControllerInst = TabsViewController()
        navigationController?.pushViewController(tabViewControllerInst, animated: true) // show destination with nav bar
    }
    
    func layoutAnimation() {
        // kick off animation in the view
        UIView.animate(withDuration: 0.7) {
            self.signInViewInst.welcomeLabelYConstraintStart.isActive = false
            self.signInViewInst.welcomeLabelYConstraintEnd.isActive = true
            
            self.signInViewInst.bullImageYConstraintStart.isActive = false
            self.signInViewInst.bullImageYConstraintEnd.isActive = true
            self.signInViewInst.bullImageWidthConstraintStart.isActive = false
            self.signInViewInst.bullImageWidthConstraintEnd.isActive = true
            self.signInViewInst.bullImageLeadingConstraintStart.isActive = false
            self.signInViewInst.bullImageLeadingConstraintEnd.isActive = true
            self.signInViewInst.bullImageHeightConstraintStart.isActive = false
            self.signInViewInst.bullImageHeightConstraintEnd.isActive = true
            
            self.signInViewInst.userNameFieldLeftConstraintStart.isActive = false
            self.signInViewInst.userNameFieldLeftConstraintEnd.isActive = true
            self.signInViewInst.userNameFieldWidthConstraintStart.isActive = false
            self.signInViewInst.userNameFieldWidthConstraintEnd.isActive = true
            
            self.signInViewInst.layoutIfNeeded()
        }
    }
    
}

