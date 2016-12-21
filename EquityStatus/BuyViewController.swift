//
//  BuyViewController.swift
//  EquityStatus
//
//  Created by Paul Tangen on 12/19/16.
//  Copyright © 2016 Paul Tangen. All rights reserved.
//

import UIKit


class BuyViewController: UIViewController {
    
    var buyViewInst: BuyView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Buy"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func loadView(){
        // hide nav bar on login page
        self.navigationController?.isNavigationBarHidden = false
        self.title = "Equity Status - Buy"
        self.navigationItem.hidesBackButton = true
        
        // load the view into the view controller
        self.buyViewInst = BuyView(frame: CGRect.zero)
        self.view = self.buyViewInst
    }

}
