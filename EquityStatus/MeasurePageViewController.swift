//
//  MeasurePageViewController.swift
//  EquityStatus
//
//  Created by Paul Tangen on 1/27/17.
//  Copyright © 2017 Paul Tangen. All rights reserved.
//

import UIKit

class MeasurePageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    let store = DataStore.sharedInstance
    var company: Company!
    var measure = String()
    
    var pages = [UIViewController](repeating: UIViewController(), count: 14)
    let pageControl = UIPageControl()
    
    // create an instance of the VC for each measure
    let ROEaViewControllerInst = CalcMeasureViewController()
    let EPSiViewControllerInst = CalcMeasureViewController()
    let EPSvViewControllerInst = CalcMeasureViewController()
    let BViViewControllerInst = CalcMeasureViewController()
    let DRaViewControllerInst = CalcMeasureViewController()
    let SOrViewControllerInst = CalcMeasureViewController()
    let previousROIViewControllerInst = CalcMeasureViewController()
    let expectedROIViewControllerInst = CalcMeasureViewController()
    let q1ViewControllerInst = QuestionMeasureViewController()
    let q2ViewControllerInst = QuestionMeasureViewController()
    let q3ViewControllerInst = QuestionMeasureViewController()
    let q4ViewControllerInst = QuestionMeasureViewController()
    let q5ViewControllerInst = QuestionMeasureViewController()
    let q6ViewControllerInst = QuestionMeasureViewController()
    
    var calcMeasureVCInstances: [(instance: CalcMeasureViewController, measure: String)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self
        self.delegate = self
        let measureInfoEPS_I = self.store.measureInfo["eps_i"]!
        let initialPage = Int(measureInfoEPS_I["pageIndex"]!)!
        
        self.edgesForExtendedLayout = []   // prevents view from siding under nav bar
        
        calcMeasureVCInstances.append((self.ROEaViewControllerInst, "roe_avg"))
        calcMeasureVCInstances.append((self.EPSiViewControllerInst, "eps_i"))
        calcMeasureVCInstances.append((self.EPSvViewControllerInst, "eps_sd"))
        calcMeasureVCInstances.append((self.BViViewControllerInst, "bv_i"))
        calcMeasureVCInstances.append((self.DRaViewControllerInst, "dr_avg"))
        calcMeasureVCInstances.append((self.SOrViewControllerInst, "so_reduced"))
        calcMeasureVCInstances.append((self.previousROIViewControllerInst, "previous_roi"))
        calcMeasureVCInstances.append((self.expectedROIViewControllerInst, "expected_roi"))
        
        for calcMeasureVCInstance in calcMeasureVCInstances {
            calcMeasureVCInstance.instance.company = company
            calcMeasureVCInstance.instance.accessibilityLabel = calcMeasureVCInstance.measure
            let pageIndexString = store.measureInfo[calcMeasureVCInstance.measure]!["pageIndex"]!
            self.pages[Int(pageIndexString)!] = calcMeasureVCInstance.instance
        }
        
        // insert page index from measureInfo
        self.pages[getPageIndex(measure: "q1")] = q1ViewControllerInst
        self.pages[getPageIndex(measure: "q2")] = q2ViewControllerInst
        self.pages[getPageIndex(measure: "q3")] = q3ViewControllerInst
        self.pages[getPageIndex(measure: "q4")] = q4ViewControllerInst
        self.pages[getPageIndex(measure: "q5")] = q5ViewControllerInst
        self.pages[getPageIndex(measure: "q6")] = q6ViewControllerInst
        
        setViewControllers([pages[initialPage]], direction: .forward, animated: true, completion: nil)
        
        // pageControl
        self.pageControl.frame = CGRect()
        self.pageControl.currentPageIndicatorTintColor = UIColor.black
        self.pageControl.pageIndicatorTintColor = UIColor.lightGray
        self.pageControl.numberOfPages = self.pages.count
        self.pageControl.currentPage = initialPage
        self.view.addSubview(self.pageControl)
        
        self.pageControl.translatesAutoresizingMaskIntoConstraints = false
        self.pageControl.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -5).isActive = true
        self.pageControl.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -20).isActive = true
        self.pageControl.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.pageControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "\(company.name.capitalized) (\(company.ticker))"
        print("measure2: \(self.measure)")
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let viewControllerIndex = self.pages.index(of: viewController) {
            if viewControllerIndex == 0 {
                return self.pages.last // wrap to last page in array
            } else {
                return self.pages[viewControllerIndex - 1] // go to previous page in array
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if let viewControllerIndex = self.pages.index(of: viewController) {
            if viewControllerIndex < self.pages.count - 1 {
                return self.pages[viewControllerIndex + 1] // go to next page in array
            } else {
                return self.pages.first // wrap to first page in array
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        // set the pageControl.currentPage to the index of the current viewController in pages
        if let viewControllers = pageViewController.viewControllers {
            if let viewControllerIndex = self.pages.index(of: viewControllers[0]) {
                self.pageControl.currentPage = viewControllerIndex
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // delete after subjective measure get pageIndex from dataStore
    func getPageIndex(measure: String) -> Int { // long names for the measures
        switch measure {
        case "roe_avg":
            return 0
        case "eps_i":
            return 1
        case "eps_sd":
            return 2
        case "bv_i":
            return 3
        case "dr_avg":
            return 4
        case "so_reduced":
            return 5
        case "previous_roi":
            return 6
        case "expected_roi":
            return 7
        case "q1":
            return 8
        case "q2":
            return 9
        case "q3":
            return 10
        case "q4":
            return 11
        case "q5":
            return 12
        case "q6":
            return 13
        default:
            return 0
        }
    }
}
