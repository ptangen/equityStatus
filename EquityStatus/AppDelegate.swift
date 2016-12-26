//
//  AppDelegate.swift
//  EquityStatus
//
//  Created by Paul Tangen on 12/18/16.
//  Copyright © 2016 Paul Tangen. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //let signInViewControllerInst = SignInViewController()
        let tabViewControllerInst = TabsViewController()
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window!.backgroundColor = UIColor.white
        //let navigationController = UINavigationController(rootViewController: signInViewControllerInst) // show signIn on startup
        let navigationController = UINavigationController(rootViewController: tabViewControllerInst) // show analysis on startup
        
        self.window!.rootViewController = navigationController
        self.window!.makeKeyAndVisible()
        
        return true
    }


}

