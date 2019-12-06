//
//  BuyViewController.swift
//  EquityStatus
//
//  Created by Paul Tangen on 12/19/16.
//  Copyright © 2016 Paul Tangen. All rights reserved.
//

import UIKit


class BuyViewController: UIViewController, BuyViewDelegate  {
    
    var buyViewInst = BuyView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.buyViewInst.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func loadView(){
        self.buyViewInst.frame = CGRect.zero
        self.view = self.buyViewInst
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
