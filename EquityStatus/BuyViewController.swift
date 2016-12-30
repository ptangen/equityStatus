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
        //self.title = "Buy"  // only used in tabBar Controller's didSelect
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func loadView(){
        // load the view into the view controller
        self.buyViewInst = BuyView(frame: CGRect.zero)
        self.view = self.buyViewInst
    }

}
