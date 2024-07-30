//
//  AppDelegate.swift
//  EquityStatus
//
//  Created by Paul Tangen on 12/18/16.
//  Copyright © 2016 Paul Tangen. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let statusBarBackground = UIView(frame: CGRect(x: 0, y: 0, width: 500, height: 20))

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // set nav bar colors
        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.tintColor = UIColor(named: .blue)
        navigationBarAppearance.backgroundColor = UIColor(named: .blue)
        navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        
        let tabViewControllerInst = TabsViewController()
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        if let window = self.window {
            window.backgroundColor = UIColor.white
            let navigationController = UINavigationController(rootViewController: tabViewControllerInst) // show buy on startup
            navigationController.view.addSubview(statusBarBackground)
            navigationController.navigationBar.tintColor = UIColor.white
        
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
        }
        return true
    }
}

