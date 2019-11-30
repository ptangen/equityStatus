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
        navigationBarAppearance.barTintColor = UIColor(named: .blue)
        navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        statusBarBackground.backgroundColor = UIColor(named: .statusBarBlue)
        //deprecated in 4.2: UIApplication.shared.statusBarStyle = .lightContent // sets status bar text color white
        
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
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "EquityStatus")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
}

