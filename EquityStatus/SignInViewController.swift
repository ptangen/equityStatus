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
        Utilities.showAlertMessage(message, viewControllerInst: self)
    }
    
    func openTabDisplay() {
        let tabViewControllerInst = TabsViewController()
        navigationController?.pushViewController(tabViewControllerInst, animated: false) // show destination with nav bar
    }
    
    func layoutAnimation() {
        // kick off animation in the view
        UIView.animate(withDuration: 0.75) {
            self.signInViewInst.welcomeLabelYConstraintStart.isActive = false
            self.signInViewInst.welcomeLabelYConstraintEnd.isActive = true
            
            self.signInViewInst.equityStatusYConstraintStart.isActive = false
            self.signInViewInst.equityStatusYConstraintEnd.isActive = true
            
            self.signInViewInst.bullImageXConstraintStart.isActive = false
            self.signInViewInst.bullImageXConstraintEnd.isActive = true
            self.signInViewInst.bullImageYConstraintStart.isActive = false
            self.signInViewInst.bullImageYConstraintEnd.isActive = true

            self.signInViewInst.bullImageWidthConstraintStart.isActive = false
            self.signInViewInst.bullImageWidthConstraintEnd.isActive = true
            self.signInViewInst.bullImageHeightConstraintStart.isActive = false
            self.signInViewInst.bullImageHeightConstraintEnd.isActive = true
            
            self.signInViewInst.signInButtonRightConstraintStart.isActive = false
            self.signInViewInst.signInButtonRightConstraintEnd.isActive = true
            
            self.signInViewInst.layoutIfNeeded()
        }
    }
    
}

