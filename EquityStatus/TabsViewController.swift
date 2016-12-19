//
//  TabsViewController.swift
//  EquityStatus
//
//  Created by Paul Tangen on 12/19/16.
//  Copyright © 2016 Paul Tangen. All rights reserved.
//

import UIKit

class TabsViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.title = "Equity Status"
        self.navigationItem.hidesBackButton = true
        
        // Create Tab Buy
        let tabBuy = BuyViewController()
        let tabBuyBarItem = UITabBarItem(title: "Buy", image: UIImage(named: "defaultImage.png"), selectedImage: UIImage(named: "selectedImage.png"))
        tabBuy.tabBarItem = tabBuyBarItem
        
        // Create Tab Analysis
        let tabAnalysis = AnalysisViewController()
        let tabAnalysisBarItem = UITabBarItem(title: "Analysis Required", image: UIImage(named: "defaultImage2.png"), selectedImage: UIImage(named: "selectedImage2.png"))
        tabAnalysis.tabBarItem = tabAnalysisBarItem
        
        // Create Tab Sell
        let tabSell = SellViewController()
        let tabSellBarItem = UITabBarItem(title: "Sell", image: UIImage(named: "defaultImage2.png"), selectedImage: UIImage(named: "selectedImage2.png"))
        tabSell.tabBarItem = tabSellBarItem
        
        self.viewControllers = [tabBuy, tabAnalysis, tabSell]
    }
    
    // UITabBarControllerDelegate method
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        //print("Selected \(viewController.title!)")
    }
}
