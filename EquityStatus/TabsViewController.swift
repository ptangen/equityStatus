//
//  TabsViewController.swift
//  EquityStatus
//
//  Created by Paul Tangen on 12/19/16.
//  Copyright © 2016 Paul Tangen. All rights reserved.
//

import UIKit

class TabsViewController: UITabBarController, UITabBarControllerDelegate {
    
    var ownViewControllerInst = OwnViewController()
    var buyViewControllerInst = BuyViewController()
    var evaluationViewControllerInst = EvaluationViewController()
    var sellViewControllerInst = SellViewController()
    var dataCollectionViewControllerInst = DataCollectionViewController()
    let store = DataStore.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        //Utilities.populateMeasureInfo()
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
        self.ownViewControllerInst = OwnViewController()
        let tabOwnBarItem = UITabBarItem(title: "Own", image: UIImage(named: "seedling"), selectedImage: UIImage(named: "seedling"))
        self.ownViewControllerInst.tabBarItem = tabOwnBarItem
        self.ownViewControllerInst.ownViewInst.setHeadingLabels()
        self.ownViewControllerInst.tabBarItem.accessibilityLabel = "ownTab"
        
        // Create Tab Buy
        self.buyViewControllerInst = BuyViewController()
        let tabBuyBarItem = UITabBarItem(title: "Buy", image: UIImage(named: "shopping-cart"), selectedImage: UIImage(named: "shopping-cart"))
        self.buyViewControllerInst.tabBarItem = tabBuyBarItem
        self.buyViewControllerInst.buyViewInst.setHeadingLabels()
        self.buyViewControllerInst.tabBarItem.accessibilityLabel = "buyTab"
        
        // Create Tab Analysis
        self.evaluationViewControllerInst = EvaluationViewController()
        let tabEvaluationBarItem = UITabBarItem(title: "Evaluate", image: UIImage(named: "insert_chart"), selectedImage: UIImage(named: "insert_chart"))
        self.evaluationViewControllerInst.tabBarItem = tabEvaluationBarItem
        self.evaluationViewControllerInst.tabBarItem.accessibilityLabel = "evalTab"
        
        // Create Tab Sell
        self.sellViewControllerInst = SellViewController()
        let tabSellBarItem = UITabBarItem(title: "Sell", image: UIImage(named: "not_interested"), selectedImage: UIImage(named: "not_interested"))
        self.sellViewControllerInst.tabBarItem = tabSellBarItem
        self.sellViewControllerInst.tabBarItem.accessibilityLabel = "sellTab"
        
        // Create Tab Data Collection
        let dataCollectionTabBarItem = UITabBarItem(title: "Data Collection", image: UIImage(named: "cloud_download"), selectedImage: UIImage(named: "cloud_download"))
        self.dataCollectionViewControllerInst.tabBarItem = dataCollectionTabBarItem
        
        
        self.viewControllers = [ownViewControllerInst, buyViewControllerInst, evaluationViewControllerInst, sellViewControllerInst, dataCollectionViewControllerInst]
        
        // add the menu button to the nav bar
        let menuButton = UIBarButtonItem(image: #imageLiteral(resourceName: "menu"), style: .plain, target: self, action: #selector(menuButtonClicked))
        menuButton.accessibilityLabel = "menuButton"
        self.navigationItem.rightBarButtonItems = [menuButton]
        self.navigationItem.setHidesBackButton(true, animated:false);
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {

        let selectedTabVC = viewController
        if let selectedTab = selectedTabVC.tabBarItem.accessibilityLabel {
            switch selectedTab {
                case "ownTab":
                    self.ownViewControllerInst.ownViewInst.updateCompanyData(selectedTab: .own)
                case "buyTab":
                    self.buyViewControllerInst.buyViewInst.updateCompanyData(selectedTab: .buy)
                case "evalTab":
                    self.evaluationViewControllerInst.evaluationViewInst.updateCompaniesToEvaluate()
                case "sellTab":
                    self.sellViewControllerInst.sellViewInst.updateCompaniesToSell()
                default:
                    print("another tab selected")
            }
        }
    }
    
    @objc func menuButtonClicked(sender: UIBarButtonItem) {
           
           let optionMenu = UIAlertController(title: nil, message: "Menu", preferredStyle: .actionSheet)
           self.dataCollectionViewControllerInst.dataCollectionViewInst.showActivityIndicator(uiView: self.dataCollectionViewControllerInst.dataCollectionViewInst)
           
           let dropCompanyTable = UIAlertAction(title: "Drop Database", style: .default, handler: { (alert: UIAlertAction!) -> Void in
               self.dataCollectionViewControllerInst.dataCollectionViewInst.dropCompanyTable(){isSuccessful in
                   if isSuccessful {
                       // select the rows and update the table
                       self.dataCollectionViewControllerInst.dataCollectionViewInst.activityIndicator.isHidden = false
                       self.dataCollectionViewControllerInst.dataCollectionViewInst.selectRows() {isSuccessful in
                           if isSuccessful {
                               self.dataCollectionViewControllerInst.dataCollectionViewInst.activityIndicator.isHidden = true
                               self.dataCollectionViewControllerInst.dataCollectionViewInst.companiesTableViewInst.reloadData()
                           }
                       }
                   }
               }
           })
           
           let addCompanyTable = UIAlertAction(title: "Add Database", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            
                self.dataCollectionViewControllerInst.dataCollectionViewInst.activityIndicator.isHidden = false
            
                DispatchQueue.main.async {
                     self.dataCollectionViewControllerInst.dataCollectionViewInst.addCompanyTable(){isSuccessful in
                        if isSuccessful {
                            // select the rows and update the table
                            self.dataCollectionViewControllerInst.dataCollectionViewInst.selectRows() {isSuccessful in
                                if isSuccessful {
                                    self.dataCollectionViewControllerInst.dataCollectionViewInst.activityIndicator.isHidden = true
                                    self.dataCollectionViewControllerInst.dataCollectionViewInst.companiesTableViewInst.reloadData()
                                }
                            }
                        }
                    }
                }
           })
           
           let reloadCompaniesTable = UIAlertAction(title: "Select Companies from DB", style: .default, handler: { (alert: UIAlertAction!) -> Void in
               self.dataCollectionViewControllerInst.dataCollectionViewInst.activityIndicator.isHidden = false
               self.dataCollectionViewControllerInst.dataCollectionViewInst.selectRows() {isSuccessful in
                   if isSuccessful {
                       self.dataCollectionViewControllerInst.dataCollectionViewInst.activityIndicator.isHidden = true
                       self.dataCollectionViewControllerInst.dataCollectionViewInst.companiesTableViewInst.reloadData()
                   }
               }
           })
           
           let updateMeasureEPSi = UIAlertAction(title: "Update EPS (1)", style: .default, handler: { (alert: UIAlertAction!) -> Void in
               let measure = "eps_i"
               self.dataCollectionViewControllerInst.dataCollectionViewInst.activityIndicator.isHidden = false
               self.dataCollectionViewControllerInst.dataCollectionViewInst.updateMeasures(measure: measure) {isSuccessful in
                   if isSuccessful {
                       self.dataCollectionViewControllerInst.dataCollectionViewInst.selectRows() {isSuccessful in
                           if isSuccessful {
                               self.dataCollectionViewControllerInst.dataCollectionViewInst.activityIndicator.isHidden = true
                               self.dataCollectionViewControllerInst.dataCollectionViewInst.companiesTableViewInst.reloadData()
                           }
                       }
                   }
               }
           })
           
           let updateMeasureROEAvg = UIAlertAction(title: "Update ROE Avg (2)", style: .default, handler: { (alert: UIAlertAction!) -> Void in
               let measure = "roe_avg"
               self.dataCollectionViewControllerInst.dataCollectionViewInst.activityIndicator.isHidden = false
               self.dataCollectionViewControllerInst.dataCollectionViewInst.updateMeasures(measure: measure) {isSuccessful in
                   if isSuccessful {
                       self.dataCollectionViewControllerInst.dataCollectionViewInst.selectRows() {isSuccessful in
                           if isSuccessful {
                               self.dataCollectionViewControllerInst.dataCollectionViewInst.activityIndicator.isHidden = true
                               self.dataCollectionViewControllerInst.dataCollectionViewInst.companiesTableViewInst.reloadData()
                           }
                       }
                   }
               }
           })
           
           let updateMeasureBVi = UIAlertAction(title: "Update BV i (2)", style: .default, handler: { (alert: UIAlertAction!) -> Void in
               let measure = "bv_i"
               self.dataCollectionViewControllerInst.dataCollectionViewInst.activityIndicator.isHidden = false
               self.dataCollectionViewControllerInst.dataCollectionViewInst.updateMeasures(measure: measure) {isSuccessful in
                   if isSuccessful {
                       self.dataCollectionViewControllerInst.dataCollectionViewInst.selectRows() {isSuccessful in
                           if isSuccessful {
                               self.dataCollectionViewControllerInst.dataCollectionViewInst.activityIndicator.isHidden = true
                               self.dataCollectionViewControllerInst.dataCollectionViewInst.companiesTableViewInst.reloadData()
                           }
                       }
                   }
               }
           })
           
           let updateMeasureSOreduced = UIAlertAction(title: "Update SO Reduced (2)", style: .default, handler: { (alert: UIAlertAction!) -> Void in
               let measure = "so_reduced"
               self.dataCollectionViewControllerInst.dataCollectionViewInst.activityIndicator.isHidden = false
               self.dataCollectionViewControllerInst.dataCollectionViewInst.updateMeasures(measure: measure) {isSuccessful in
                   if isSuccessful {
                       self.dataCollectionViewControllerInst.dataCollectionViewInst.selectRows() {isSuccessful in
                           if isSuccessful {
                               self.dataCollectionViewControllerInst.dataCollectionViewInst.activityIndicator.isHidden = true
                               self.dataCollectionViewControllerInst.dataCollectionViewInst.companiesTableViewInst.reloadData()
                           }
                       }
                   }
               }
           })
           
           let updateMeasureDRAvg = UIAlertAction(title: "Update DR Avg (2)", style: .default, handler: { (alert: UIAlertAction!) -> Void in
               let measure = "dr_avg"
                self.dataCollectionViewControllerInst.dataCollectionViewInst.activityIndicator.isHidden = false
               self.dataCollectionViewControllerInst.dataCollectionViewInst.updateMeasures(measure: measure) {isSuccessful in
                   if isSuccessful {
                       self.dataCollectionViewControllerInst.dataCollectionViewInst.selectRows() {isSuccessful in
                           if isSuccessful {
                               self.dataCollectionViewControllerInst.dataCollectionViewInst.activityIndicator.isHidden = true
                               self.dataCollectionViewControllerInst.dataCollectionViewInst.companiesTableViewInst.reloadData()
                           }
                       }
                   }
               }
           })
           
           let updateMeasurePEAvg = UIAlertAction(title: "Update PE Avg / PE Change (2)", style: .default, handler: { (alert: UIAlertAction!) -> Void in
               let measure = "pe_avg"
               self.dataCollectionViewControllerInst.dataCollectionViewInst.activityIndicator.isHidden = false
               self.dataCollectionViewControllerInst.dataCollectionViewInst.updateMeasures(measure: measure) {isSuccessful in
                   if isSuccessful {
                       self.dataCollectionViewControllerInst.dataCollectionViewInst.selectRows() {isSuccessful in
                           if isSuccessful {
                               self.dataCollectionViewControllerInst.dataCollectionViewInst.activityIndicator.isHidden = true
                               self.dataCollectionViewControllerInst.dataCollectionViewInst.companiesTableViewInst.reloadData()
                           }
                       }
                   }
               }
           })
           
           let updateExpectedROI = UIAlertAction(title: "Update Expected ROI (3)", style: .default, handler: { (alert: UIAlertAction!) -> Void in
               self.dataCollectionViewControllerInst.dataCollectionViewInst.activityIndicator.isHidden = false
               self.dataCollectionViewControllerInst.dataCollectionViewInst.updateROI(measure: "expected_roi"){ isSuccessful in
                   if isSuccessful {
                       self.dataCollectionViewControllerInst.dataCollectionViewInst.selectRows() {isSuccessful in
                           if isSuccessful {
                               self.dataCollectionViewControllerInst.dataCollectionViewInst.activityIndicator.isHidden = true
                               self.dataCollectionViewControllerInst.dataCollectionViewInst.companiesTableViewInst.reloadData()
                           }
                       }
                   }
               }
           })
           
           let updatePreviousROI = UIAlertAction(title: "Update Previous ROI (4)", style: .default, handler: { (alert: UIAlertAction!) -> Void in
               self.dataCollectionViewControllerInst.dataCollectionViewInst.activityIndicator.isHidden = false
               self.dataCollectionViewControllerInst.dataCollectionViewInst.updateROI(measure: "previous_roi"){ isSuccessful in
                   if isSuccessful {
                       self.dataCollectionViewControllerInst.dataCollectionViewInst.selectRows() {isSuccessful in
                           if isSuccessful {
                               self.dataCollectionViewControllerInst.dataCollectionViewInst.activityIndicator.isHidden = true
                               self.dataCollectionViewControllerInst.dataCollectionViewInst.companiesTableViewInst.reloadData()
                           }
                       }
                   }
               }
           })
           
           let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert: UIAlertAction!) -> Void in })
           
           // Add actions to menu and display
           optionMenu.addAction(updateMeasureEPSi)
           optionMenu.addAction(updateMeasureROEAvg)
           optionMenu.addAction(updateMeasureBVi)
           optionMenu.addAction(updateMeasureSOreduced)
           optionMenu.addAction(updateMeasureDRAvg)
           optionMenu.addAction(updateMeasurePEAvg)
           optionMenu.addAction(updateExpectedROI)
           optionMenu.addAction(updatePreviousROI)
           
           optionMenu.addAction(addCompanyTable)
           optionMenu.addAction(reloadCompaniesTable)
           optionMenu.addAction(dropCompanyTable)

           optionMenu.addAction(cancelAction)
           self.present(optionMenu, animated: true, completion: nil)
       }
}
