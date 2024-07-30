//
//  TabsViewController.swift
//  EquityStatus
//
//  Created by Paul Tangen on 12/19/16.
//  Copyright © 2016 Paul Tangen. All rights reserved.
//

import UIKit

class TabsViewController: UITabBarController, UITabBarControllerDelegate {
    
    var watchViewControllerInst = WatchViewController()
    var evaluationViewControllerInst = EvaluationViewController()
    var sellViewControllerInst = SellViewController()
    var dataCollectionViewControllerInst = DataCollectionViewController()
    let store = DataStore.sharedInstance
    let confirmDropTableAlert = UIAlertController(title: "Confirm Request", message: "Are you sure you want to drop the database?", preferredStyle: .alert)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        self.confirmDropTableAlert.addAction(UIAlertAction(title: "Drop DB", style: .default, handler: { action in  self.dataCollectionViewControllerInst.dataCollectionViewInst.dropCompanyTable(){isSuccessful in
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
        }))
        self.confirmDropTableAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
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
        
        // Create Tab Watch
        self.watchViewControllerInst = WatchViewController()
        let tabWatchBarItem = UITabBarItem(title: "Watch", image: UIImage(named: "seedling"), selectedImage: UIImage(named: "seedling"))
        self.watchViewControllerInst.tabBarItem = tabWatchBarItem
        self.watchViewControllerInst.watchViewInst.setHeadingLabels()
        self.watchViewControllerInst.tabBarItem.accessibilityLabel = "watchTab"
        
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
        
        self.viewControllers = [watchViewControllerInst, evaluationViewControllerInst, sellViewControllerInst, dataCollectionViewControllerInst]
        
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
                case "watchTab":
                self.watchViewControllerInst.watchViewInst.updateCompanyData(selectedTab: .watch)
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
           
           let dropCompanyTable = UIAlertAction(title: "Drop Database", style: .default, handler: { (alert: UIAlertAction!) -> Void in self.present(self.confirmDropTableAlert, animated: true)
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
           
            let updateMeasuresAB = UIAlertAction(title: "Update Historical Data A-B", style: .default, handler: { (alert: UIAlertAction!) -> Void in
                let setOfTickers = "A-B" // C-E, F-N, O-S, T-Z
                self.dataCollectionViewControllerInst.dataCollectionViewInst.activityIndicator.isHidden = false
                self.dataCollectionViewControllerInst.dataCollectionViewInst.updateHistoricalMeasures(setOfTickers: setOfTickers) {isSuccessful in
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
        
            let updateMeasuresCE = UIAlertAction(title: "Update Historical Data C-E", style: .default, handler: { (alert: UIAlertAction!) -> Void in
                let setOfTickers = "C-E"
                self.dataCollectionViewControllerInst.dataCollectionViewInst.activityIndicator.isHidden = false
                self.dataCollectionViewControllerInst.dataCollectionViewInst.updateHistoricalMeasures(setOfTickers: setOfTickers) {isSuccessful in
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
        
            let updateMeasuresFJ = UIAlertAction(title: "Update Historical Data F-J", style: .default, handler: { (alert: UIAlertAction!) -> Void in
                let setOfTickers = "F-J"
                self.dataCollectionViewControllerInst.dataCollectionViewInst.activityIndicator.isHidden = false
                self.dataCollectionViewControllerInst.dataCollectionViewInst.updateHistoricalMeasures(setOfTickers: setOfTickers) {isSuccessful in
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
        
            let updateMeasuresKN = UIAlertAction(title: "Update Historical Data K-N", style: .default, handler: { (alert: UIAlertAction!) -> Void in
                let setOfTickers = "K-N"
                self.dataCollectionViewControllerInst.dataCollectionViewInst.activityIndicator.isHidden = false
                self.dataCollectionViewControllerInst.dataCollectionViewInst.updateHistoricalMeasures(setOfTickers: setOfTickers) {isSuccessful in
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
        
            let updateMeasuresOR = UIAlertAction(title: "Update Historical Data O-R", style: .default, handler: { (alert: UIAlertAction!) -> Void in
                let setOfTickers = "O-R"
                self.dataCollectionViewControllerInst.dataCollectionViewInst.activityIndicator.isHidden = false
                self.dataCollectionViewControllerInst.dataCollectionViewInst.updateHistoricalMeasures(setOfTickers: setOfTickers) {isSuccessful in
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
        
            let updateMeasuresST = UIAlertAction(title: "Update Historical Data S-T", style: .default, handler: { (alert: UIAlertAction!) -> Void in
                let setOfTickers = "S-T"
                self.dataCollectionViewControllerInst.dataCollectionViewInst.activityIndicator.isHidden = false
                self.dataCollectionViewControllerInst.dataCollectionViewInst.updateHistoricalMeasures(setOfTickers: setOfTickers) {isSuccessful in
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
        
            let updateMeasuresUZ = UIAlertAction(title: "Update Historical Data U-Z", style: .default, handler: { (alert: UIAlertAction!) -> Void in
                let setOfTickers = "U-Z"
                self.dataCollectionViewControllerInst.dataCollectionViewInst.activityIndicator.isHidden = false
                self.dataCollectionViewControllerInst.dataCollectionViewInst.updateHistoricalMeasures(setOfTickers: setOfTickers) {isSuccessful in
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
            optionMenu.addAction(updateMeasuresAB)
            optionMenu.addAction(updateMeasuresCE)
            optionMenu.addAction(updateMeasuresFJ)
            optionMenu.addAction(updateMeasuresKN)
            optionMenu.addAction(updateMeasuresOR)
            optionMenu.addAction(updateMeasuresST)
            optionMenu.addAction(updateMeasuresUZ)
            optionMenu.addAction(updateExpectedROI)
            optionMenu.addAction(updatePreviousROI)
           
            optionMenu.addAction(addCompanyTable)
            optionMenu.addAction(reloadCompaniesTable)
            optionMenu.addAction(dropCompanyTable)

            optionMenu.addAction(cancelAction)
            self.present(optionMenu, animated: true, completion: nil)
       }
}
