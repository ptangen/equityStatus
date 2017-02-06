//
//  TabsViewController.swift
//  EquityStatus
//
//  Created by Paul Tangen on 12/19/16.
//  Copyright © 2016 Paul Tangen. All rights reserved.
//

import UIKit

class TabsViewController: UITabBarController, UITabBarControllerDelegate {
    
    var buyViewControllerInst = BuyViewController()
    var evaluationViewControllerInst = EvaluationViewController()
    var sellViewControllerInst = SellViewController()
    let store = DataStore.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        // fetch the equities if needed
        self.store.equities.isEmpty ? self.fetchBuyEvalData() : ()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.title = "Equity Status"
        self.navigationItem.hidesBackButton = true
        UITabBar.appearance().tintColor = UIColor(named: .statusBarBlue)
        
        // Create Tab Buy
        self.buyViewControllerInst = BuyViewController()
        let tabBuyBarItem = UITabBarItem(title: "Buy", image: UIImage(named: "sentiment_satisfied"), selectedImage: UIImage(named: "sentiment_satisfied"))
        self.buyViewControllerInst.tabBarItem = tabBuyBarItem
        self.buyViewControllerInst.buyViewInst.setHeadingLabels()
        
        // Create Tab Analysis
        self.evaluationViewControllerInst = EvaluationViewController()
        let tabEvaluationBarItem = UITabBarItem(title: "Evaluate", image: UIImage(named: "insert_chart"), selectedImage: UIImage(named: "insert_chart"))
        self.evaluationViewControllerInst.tabBarItem = tabEvaluationBarItem
        
        // Create Tab Sell
        self.sellViewControllerInst = SellViewController()
        let tabSellBarItem = UITabBarItem(title: "Sell", image: UIImage(named: "not_interested"), selectedImage: UIImage(named: "not_interested"))
        sellViewControllerInst.tabBarItem = tabSellBarItem
        
        self.viewControllers = [buyViewControllerInst, evaluationViewControllerInst, sellViewControllerInst]
        
        // add the menu button to the nav bar
        let menuButton = UIBarButtonItem(image: #imageLiteral(resourceName: "menu"), style: .plain, target: self, action: #selector(menuButtonClicked))
        self.navigationItem.rightBarButtonItems = [menuButton]
        self.navigationItem.setHidesBackButton(true, animated:false);
    }
    
    func fetchBuyEvalData() {

        // display buy tab with no data
        OperationQueue.main.addOperation {
            self.buyViewControllerInst.buyViewInst.pageLayoutNoData()
            self.buyViewControllerInst.buyViewInst.pageDescLabel.text = "Searching for companies that have passed all 14 measures."
            self.buyViewControllerInst.buyViewInst.countLabel.text = "?"
            self.buyViewControllerInst.buyViewInst.showActivityIndicator(uiView: self.buyViewControllerInst.buyViewInst)
            self.buyViewControllerInst.buyViewInst.barChartView.isHidden = true
        
            // display eval tab with no data
            self.evaluationViewControllerInst.evaluationViewInst.pageDescLabel.text = "Searching for equities to evaluate..."
            self.evaluationViewControllerInst.evaluationViewInst.countLabel.text = "?"
            self.evaluationViewControllerInst.evaluationViewInst.showActivityIndicator(uiView: self.evaluationViewControllerInst.evaluationViewInst)
            self.evaluationViewControllerInst.evaluationViewInst.evaluationTableViewInst.isHidden = true
        }
        
        APIClient.getEquitiesFromDB(mode: "pass,passOrNoData"){isSuccessful in
            if isSuccessful {
                OperationQueue.main.addOperation {
                    // update the buy View
                    self.buyViewControllerInst.buyViewInst.createEquitiesForBuy()
                    self.buyViewControllerInst.buyViewInst.setHeadingLabels()
                    self.buyViewControllerInst.buyViewInst.pageLayoutWithData()
                    self.buyViewControllerInst.buyViewInst.barChartView.isHidden = false
                    self.buyViewControllerInst.buyViewInst.activityIndicator.isHidden = true
                    
                    // update the evaluation tab
                    self.evaluationViewControllerInst.evaluationViewInst.createEquitiesForEvaluation()
                    self.evaluationViewControllerInst.evaluationViewInst.evaluationTableViewInst.reloadData()
                    self.evaluationViewControllerInst.evaluationViewInst.setHeadingLabels()
                    self.evaluationViewControllerInst.evaluationViewInst.evaluationTableViewInst.isHidden = false
                    self.evaluationViewControllerInst.evaluationViewInst.activityIndicator.isHidden = true
                }
            } else {
                OperationQueue.main.addOperation {
                    self.buyViewControllerInst.buyViewInst.activityIndicator.isHidden = true
                    self.evaluationViewControllerInst.evaluationViewInst.activityIndicator.isHidden = true
                }
                // show error message
                Utilities.showAlertMessage("Unable to retrieve data from the server. Please notify ptangen@ptangen.com of situation.", viewControllerInst: self)
            }
        }
    }
    
//    // UITabBarControllerDelegate method
//    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//        //print("Selected \(viewController.title!)")
//    }
    
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
