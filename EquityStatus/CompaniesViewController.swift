//
//  CompaniesViewController.swift
//  EquityStatus
//
//  Created by Paul Tangen on 11/16/19.
//  Copyright © 2019 Paul Tangen. All rights reserved.
//

import UIKit

class CompaniesViewController: UIViewController {
    
    var companiesViewInst = CompaniesView()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func loadView(){
        self.companiesViewInst.frame = CGRect.zero
        self.view = self.companiesViewInst
    }
}

