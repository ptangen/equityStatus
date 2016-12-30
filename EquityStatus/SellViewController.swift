//
//  SellViewController.swift
//  EquityStatus
//
//  Created by Paul Tangen on 12/19/16.
//  Copyright © 2016 Paul Tangen. All rights reserved.
//

import UIKit

class SellViewController: UIViewController, SellViewDelegate {
    
    var sellViewInst: SellView!
    let store = DataStore.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.title = "Sell" // only used in tabBar Controller's didSelect
        self.sellViewInst.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func loadView(){
        // load the view into the view controller
        self.sellViewInst = SellView(frame: CGRect.zero)
        self.view = self.sellViewInst
    }
    
    func openDetail(_ rowItem: String) {

        // extract the ticker from the rowItem
        let ticker = getSubStringBetweenParens(fullString: rowItem)

        // try to get the equity from the dataStore, if it is not there fetch it from the API
        if let equity = store.getEquityByTickerFromStore(ticker: ticker) {
            // open the detail view for the selected equity
            let detailViewControllerInst = DetailViewController()
            detailViewControllerInst.equity = equity
            navigationController?.pushViewController(detailViewControllerInst, animated: false)
        } else {
            // fetch the equity from the api and display the details
            APIClient.getEquitiesFromDB(mode: "t:\(ticker)"){
                OperationQueue.main.addOperation {
                    if let equity = self.store.getEquityByTickerFromStore(ticker: ticker) {
                        // open the detail view for the selected equity
                        let detailViewControllerInst = DetailViewController()
                        detailViewControllerInst.equity = equity
                        self.navigationController?.pushViewController(detailViewControllerInst, animated: false)
                    }
                }
            }
        }
    }
    
    func getSubStringBetweenParens(fullString: String) -> String {
        
        let chars = fullString.characters;
        
        // Get character indexes.
        let indexLeftParen = chars.index(of: "(")!
        let indexRightParen = chars.index(of: ")")!
        
        // Get before and after indexes.
        let indexAfterLeftParen = chars.index(after: indexLeftParen)
        let indexBeforeRightParen = chars.index(before: indexRightParen)
        
        return fullString[indexAfterLeftParen...indexBeforeRightParen]
        
    }

}
