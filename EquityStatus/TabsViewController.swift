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
        let tabBuyBarItem = UITabBarItem(title: "Buy", image: UIImage(named: "sentiment_satisfied"), selectedImage: UIImage(named: "sentiment_satisfied"))
        tabBuy.tabBarItem = tabBuyBarItem
        
        // Create Tab Analysis
        let tabAnalysis = AnalysisViewController()
        let tabAnalysisBarItem = UITabBarItem(title: "Analysis Required", image: UIImage(named: "insert_chart"), selectedImage: UIImage(named: "insert_chart"))
        tabAnalysis.tabBarItem = tabAnalysisBarItem
        
        // Create Tab Sell
        let tabSell = SellViewController()
        let tabSellBarItem = UITabBarItem(title: "Sell", image: UIImage(named: "not_interested"), selectedImage: UIImage(named: "not_interested"))
        tabSell.tabBarItem = tabSellBarItem
        
        self.viewControllers = [tabBuy, tabAnalysis, tabSell]
        
        // add the menu button to the nav bar
        let menuButton = UIBarButtonItem(title: Constants.iconLibrary.menu.rawValue, style: .plain, target: self, action: #selector(menuButtonClicked))
        let menuButtonAttributes = [
            NSForegroundColorAttributeName: UIColor(named: .blue),
            NSFontAttributeName: UIFont(name: Constants.iconFont.material.rawValue, size: CGFloat(Constants.iconSize.small.rawValue))
        ]
        menuButton.setTitleTextAttributes(menuButtonAttributes, for: .normal)
        self.navigationItem.rightBarButtonItems = [menuButton]
        self.navigationItem.setHidesBackButton(true, animated:false);
    }
    
    // UITabBarControllerDelegate method
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        //print("Selected \(viewController.title!)")
    }
    
    func menuButtonClicked(sender: UIBarButtonItem) {
        
        let optionMenu = UIAlertController(title: nil, message: "Menu", preferredStyle: .actionSheet)
        
        let signOutAction = UIAlertAction(title: "Sign Out", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            let signInControllerInst = SignInViewController()
            self.navigationController?.pushViewController(signInControllerInst, animated: true) // show destination with nav bar
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert: UIAlertAction!) -> Void in })
        
        // Add actions to menu and display
        optionMenu.addAction(signOutAction)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }

}
