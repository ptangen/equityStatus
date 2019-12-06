//
//  SellViewController.swift
//  EquityStatus
//
//  Created by Paul Tangen on 12/19/16.
//  Copyright © 2016 Paul Tangen. All rights reserved.
//

import UIKit

class SellViewController: UIViewController, SellViewDelegate {
    
    var sellViewInst = SellView()
    let store = DataStore.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sellViewInst.delegate = self
        definesPresentationContext = true  // for searchbar
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func loadView(){
        self.sellViewInst.frame = CGRect.zero
        self.view = self.sellViewInst
    }
    
    func openDetail(company: Company) {
        let companyDetailViewControllerInst = CompanyDetailViewController()
        companyDetailViewControllerInst.company = company
        navigationController?.pushViewController(companyDetailViewControllerInst, animated: false)
    }
    
    func showAlertMessage(_ message: String) {
        Utilities.showAlertMessage(message, viewControllerInst: self)
    }
}
