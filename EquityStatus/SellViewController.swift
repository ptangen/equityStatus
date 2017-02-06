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
        self.sellViewInst.getEquityMetadata()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.sellViewInst.sellViewItemCount = Utilities.getSellTabCount()
        self.sellViewInst.sellViewItemCount == 0 ? (sellViewInst.countLabel.text = "?") : (sellViewInst.countLabel.text = String(self.sellViewInst.sellViewItemCount))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func loadView(){
        self.sellViewInst.frame = CGRect.zero
        self.view = self.sellViewInst
    }
    
    func openDetail(_ ticker: String) {
        // try to get the equity from the dataStore, if it is not there fetch it from the API
        if let equity = store.getEquityByTickerFromStore(ticker: ticker) {
            // open the detail view for the selected equity
            let equityDetailViewControllerInst = EquityDetailViewController()
            equityDetailViewControllerInst.equity = equity
            navigationController?.pushViewController(equityDetailViewControllerInst, animated: false)
        } else {
            // fetch the equity from the api and display the details
            APIClient.getEquitiesFromDB(mode: "t:\(ticker)"){isSuccessful in
                if isSuccessful {
                    OperationQueue.main.addOperation {
                        if let equity = self.store.getEquityByTickerFromStore(ticker: ticker) {
                            // open the detail view for the selected equity
                            let equityDetailViewControllerInst = EquityDetailViewController()
                            equityDetailViewControllerInst.equity = equity
                            self.navigationController?.pushViewController(equityDetailViewControllerInst, animated: false)
                        }
                    }
                } else {
                    Utilities.showAlertMessage("Error retriving data from the server.", viewControllerInst: self)
                }
            }
        }
    }
    
    func showAlertMessage(_ message: String) {
        Utilities.showAlertMessage(message, viewControllerInst: self)
    }
}
