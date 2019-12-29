//
//  OwnViewController.swift
//  EquityStatus
//
//  Created by Paul Tangen on 12/28/19.
//  Copyright © 2019 Paul Tangen. All rights reserved.
//

import UIKit

class OwnViewController: UIViewController, OwnViewDelegate  {
    
    var ownViewInst = OwnView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.ownViewInst.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func loadView(){
        self.ownViewInst.frame = CGRect.zero
        self.view = self.ownViewInst
    }
    
    func openCompanyDetail(company: Company) {
        let companyDetailViewControllerInst = CompanyDetailViewController()
        companyDetailViewControllerInst.company = company
        self.title = "" // this value is passed to the back button label in the destination VC
        navigationController?.pushViewController(companyDetailViewControllerInst, animated: false) // show destination with nav bar
        navigationController?.navigationBar.backItem?.accessibilityLabel = "backButton"
    }
    
    func showAlertMessage(_ message: String) {
        Utilities.showAlertMessage(message, viewControllerInst: self)
    }
}

