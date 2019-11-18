//
//  AdminTabsViewController.swift
//  EquityStatus
//
//  Created by Paul Tangen on 11/16/19.
//  Copyright © 2019 Paul Tangen. All rights reserved.
//

import UIKit

class AdminTabsViewController: UITabBarController, UITabBarControllerDelegate {
    
    var companiesViewControllerInst = CompaniesViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        // fetch the equities if needed
        //self.store.equities.isEmpty ? self.fetchBuyEvalData() : ()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.title = "Administration"
        self.navigationItem.hidesBackButton = true
        UITabBar.appearance().tintColor = UIColor(named: .statusBarBlue)
        
        // Create Tab Companies
        let tabCompaniesBarItem = UITabBarItem(title: "Companies", image: UIImage(named: "sentiment_satisfied"), selectedImage: UIImage(named: "sentiment_satisfied"))
        self.companiesViewControllerInst.tabBarItem = tabCompaniesBarItem
       
        
        self.viewControllers = [companiesViewControllerInst]
        
        // add the menu button to the nav bar
        let menuButton = UIBarButtonItem(image: #imageLiteral(resourceName: "menu"), style: .plain, target: self, action: #selector(menuButtonClicked))
        menuButton.accessibilityLabel = "menuButton"
        self.navigationItem.rightBarButtonItems = [menuButton]
        self.navigationItem.setHidesBackButton(true, animated:false);
    }
    
    @objc func menuButtonClicked(sender: UIBarButtonItem) {
        
        let optionMenu = UIAlertController(title: nil, message: "Menu", preferredStyle: .actionSheet)
        
        let signOutAction = UIAlertAction(title: "Sign Out", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            //let signInControllerInst = SignInViewController()
            //self.navigationController?.pushViewController(signInControllerInst, animated: true) // show destination with nav bar
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert: UIAlertAction!) -> Void in })
        
        // Add actions to menu and display
        //optionMenu.addAction(signOutAction)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
}
