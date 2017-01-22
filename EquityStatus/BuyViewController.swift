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
        self.buyViewInst = BuyView(frame: CGRect.zero)
        self.view = self.buyViewInst
    }
    
    func openEquityDetail(_ equity: Equity) {
        let equityDetailViewControllerInst = EquityDetailViewController()
        equityDetailViewControllerInst.equity = equity
        self.title = "" // this value is passed to the back button label in the destination VC
        navigationController?.pushViewController(equityDetailViewControllerInst, animated: false) // show destination with nav bar
    }
    
    func showAlertMessage(_ message: String) {
        Utilities.showAlertMessage(message, viewControllerInst: self)
    }
}
