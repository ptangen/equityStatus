//
//  EvaluationViewController.swift
//  EquityStatus
//
//  Created by Paul Tangen on 12/19/16.
//  Copyright © 2016 Paul Tangen. All rights reserved.
//

import UIKit

class EvaluationViewController: UIViewController, EvaluationViewDelegate {
    
    var evaluationViewInst = EvaluationView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.evaluationViewInst.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func loadView(){
        self.evaluationViewInst.frame = CGRect.zero
        self.view = self.evaluationViewInst
    }
    
    func openCompanyDetail(company: Company) {
        let companyDetailViewControllerInst = CompanyDetailViewController()
        companyDetailViewControllerInst.company = company
        self.title = "" // this value is passed to the back button label in the destination VC
        navigationController?.pushViewController(companyDetailViewControllerInst, animated: false) // show destination with nav bar
    }
}
