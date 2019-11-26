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
        let companiesTabBarItem = UITabBarItem(title: "Companies", image: UIImage(named: "sentiment_satisfied"), selectedImage: UIImage(named: "sentiment_satisfied"))
        self.companiesViewControllerInst.tabBarItem = companiesTabBarItem
        
        // Create Tab Measures
        let measuresTabBarItem = UITabBarItem(title: "Measures", image: UIImage(named: "sentiment_satisfied"), selectedImage: UIImage(named: "sentiment_satisfied"))
               
        self.viewControllers = [self.companiesViewControllerInst]
        
        // add the menu button to the nav bar
        let menuButton = UIBarButtonItem(image: #imageLiteral(resourceName: "menu"), style: .plain, target: self, action: #selector(menuButtonClicked))
        menuButton.accessibilityLabel = "menuButton"
        self.navigationItem.rightBarButtonItems = [menuButton]
        self.navigationItem.setHidesBackButton(true, animated:false);
    }
    
    @objc func menuButtonClicked(sender: UIBarButtonItem) {
        
        let optionMenu = UIAlertController(title: nil, message: "Menu", preferredStyle: .actionSheet)
        let companiesViewControllerInst = CompaniesViewController()
        
        let dropCompanyTable = UIAlertAction(title: "Drop Company Table", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            companiesViewControllerInst.companiesViewInst.dropCompanyTable(){isSuccessful in
                if isSuccessful {
                    // select the rows and update the table
                    self.companiesViewControllerInst.companiesViewInst.selectRows() {isSuccessful in
                        if isSuccessful {
                            self.companiesViewControllerInst.companiesViewInst.companiesTableViewInst.reloadData()
                        }
                    }
                }
            }
        })
        
        let addCompanyTable = UIAlertAction(title: "Add Company Table", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            companiesViewControllerInst.companiesViewInst.addCompanyTable(){isSuccessful in
                if isSuccessful {
                    // select the rows and update the table
                    self.companiesViewControllerInst.companiesViewInst.selectRows() {isSuccessful in
                        if isSuccessful {
                            self.companiesViewControllerInst.companiesViewInst.companiesTableViewInst.reloadData()
                        }
                    }
                }
            }
        })
        
        let reloadCompaniesTable = UIAlertAction(title: "Reload Company View", style: .default, handler: { (alert: UIAlertAction!) -> Void in
                
                print("refreshTableView")
                self.companiesViewControllerInst.companiesViewInst.selectRows() {isSuccessful in
                    if isSuccessful {
                        self.companiesViewControllerInst.companiesViewInst.companiesTableViewInst.reloadData()
                    }
                }
        })
        
        let updateMeasureEPSi = UIAlertAction(title: "Update EPS", style: .default, handler: { (alert: UIAlertAction!) -> Void in
                let measure = "eps_i"
                self.companiesViewControllerInst.companiesViewInst.updateMeasures(measure: measure) {isSuccessful in
                    if isSuccessful {
                        self.companiesViewControllerInst.companiesViewInst.selectRows() {isSuccessful in
                            if isSuccessful {
                                self.companiesViewControllerInst.companiesViewInst.companiesTableViewInst.reloadData()
                            }
                        }
                    }
                }
            }
        )
        
        let updateMeasureROEAvg = UIAlertAction(title: "Update ROE Avg", style: .default, handler: { (alert: UIAlertAction!) -> Void in
                let measure = "roe_avg"
                self.companiesViewControllerInst.companiesViewInst.updateMeasures(measure: measure) {isSuccessful in
                        if isSuccessful {
                            self.companiesViewControllerInst.companiesViewInst.selectRows() {isSuccessful in
                                if isSuccessful {
                                    self.companiesViewControllerInst.companiesViewInst.companiesTableViewInst.reloadData()
                                }
                            }
                        }
                   }
            }
        )
        
        let updateMeasureBVi = UIAlertAction(title: "Update BV i", style: .default, handler: { (alert: UIAlertAction!) -> Void in
                let measure = "bv_i"
                self.companiesViewControllerInst.companiesViewInst.updateMeasures(measure: measure) {isSuccessful in
                        if isSuccessful {
                            self.companiesViewControllerInst.companiesViewInst.selectRows() {isSuccessful in
                                if isSuccessful {
                                    self.companiesViewControllerInst.companiesViewInst.companiesTableViewInst.reloadData()
                                }
                            }
                        }
                   }
            }
        )
        
        let updateMeasureSOreduced = UIAlertAction(title: "Update SO Reduced", style: .default, handler: { (alert: UIAlertAction!) -> Void in
                let measure = "so_reduced"
                self.companiesViewControllerInst.companiesViewInst.updateMeasures(measure: measure) {isSuccessful in
                        if isSuccessful {
                            self.companiesViewControllerInst.companiesViewInst.selectRows() {isSuccessful in
                                if isSuccessful {
                                    self.companiesViewControllerInst.companiesViewInst.companiesTableViewInst.reloadData()
                                }
                            }
                        }
                   }
            }
        )
        
        let updateMeasureDRAvg = UIAlertAction(title: "Update DR Avg", style: .default, handler: { (alert: UIAlertAction!) -> Void in
                let measure = "dr_avg"
                self.companiesViewControllerInst.companiesViewInst.updateMeasures(measure: measure) {isSuccessful in
                        if isSuccessful {
                            self.companiesViewControllerInst.companiesViewInst.selectRows() {isSuccessful in
                                if isSuccessful {
                                    self.companiesViewControllerInst.companiesViewInst.companiesTableViewInst.reloadData()
                                }
                            }
                        }
                   }
            }
        )
        
        let updateMeasurePEAvg = UIAlertAction(title: "Update PE Avg for ROI", style: .default, handler: { (alert: UIAlertAction!) -> Void in
                let measure = "pe_avg"
                self.companiesViewControllerInst.companiesViewInst.updateMeasures(measure: measure) {isSuccessful in
                        if isSuccessful {
                            self.companiesViewControllerInst.companiesViewInst.selectRows() {isSuccessful in
                                if isSuccessful {
                                    self.companiesViewControllerInst.companiesViewInst.companiesTableViewInst.reloadData()
                                }
                            }
                        }
                   }
            }
        )
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert: UIAlertAction!) -> Void in })
        
        // Add actions to menu and display
        optionMenu.addAction(updateMeasureEPSi)
        optionMenu.addAction(updateMeasureROEAvg)
        optionMenu.addAction(updateMeasureBVi)
        optionMenu.addAction(updateMeasureSOreduced)
        optionMenu.addAction(updateMeasureDRAvg)
        optionMenu.addAction(updateMeasurePEAvg)
        
        optionMenu.addAction(addCompanyTable)
        optionMenu.addAction(reloadCompaniesTable)
        optionMenu.addAction(dropCompanyTable)

        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
}
