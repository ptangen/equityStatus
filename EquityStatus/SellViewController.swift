//
//  SellViewController.swift
//  EquityStatus
//
//  Created by Paul Tangen on 12/19/16.
//  Copyright © 2016 Paul Tangen. All rights reserved.
//

import UIKit

class SellViewController: UIViewController {
    
    var sellViewInst: SellView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Sell"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func loadView(){
        // load the view into the view controller
        self.sellViewInst = SellView(frame: CGRect.zero)
        self.view = self.sellViewInst
    }

}
