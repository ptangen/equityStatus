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
    
    var pages = [UIViewController](repeating: UIViewController(), count: 15)
    let pageControl = UIPageControl()
    
    // create an instance of the VC for each measure
    let eps_i_ViewControllerInst = CalcMeasureViewController(),
        eps_sd_ViewControllerInst = CalcMeasureViewController(),
        roe_avg_ViewControllerInst = CalcMeasureViewController(),
        bv_i_ViewControllerInst = CalcMeasureViewController(),
        dr_avg_ViewControllerInst = CalcMeasureViewController(),
        so_reduced_ViewControllerInst = CalcMeasureViewController(),
        previous_roi_ViewControllerInst = CalcMeasureViewController(),
        expected_roi_ViewControllerInst = CalcMeasureViewController(),
        q1_ViewControllerInst = QuestionMeasureViewController(),
        q2_ViewControllerInst = QuestionMeasureViewController(),
        q3_ViewControllerInst = QuestionMeasureViewController(),
        q4_ViewControllerInst = QuestionMeasureViewController(),
        q5_ViewControllerInst = QuestionMeasureViewController(),
        q6_ViewControllerInst = QuestionMeasureViewController(),
        own_ViewControllerInst = QuestionMeasureViewController()
    
    var calcMeasureVCInstances: [(instance: CalcMeasureViewController, measure: String)] = []
    var subjectiveMeasureVCInstances: [(instance: QuestionMeasureViewController, measure: String)] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        self.dataSource = self
        self.delegate = self
        let measureInfo = self.store.measureInfo[self.measure]!
        let initialPage = Int(measureInfo["pageIndex"]!)!
        
        self.edgesForExtendedLayout = []   // prevents view from siding under nav bar
        
        // add attribute values to measure pages
        calcMeasureVCInstances.append((self.roe_avg_ViewControllerInst, "roe_avg"))
        calcMeasureVCInstances.append((self.eps_i_ViewControllerInst, "eps_i"))
        calcMeasureVCInstances.append((self.eps_sd_ViewControllerInst, "eps_sd"))
        calcMeasureVCInstances.append((self.bv_i_ViewControllerInst, "bv_i"))
        calcMeasureVCInstances.append((self.dr_avg_ViewControllerInst, "dr_avg"))
        calcMeasureVCInstances.append((self.so_reduced_ViewControllerInst, "so_reduced"))
        calcMeasureVCInstances.append((self.previous_roi_ViewControllerInst, "previous_roi"))
        calcMeasureVCInstances.append((self.expected_roi_ViewControllerInst, "expected_roi"))
        
        for calcMeasureVCInstance in calcMeasureVCInstances {
            calcMeasureVCInstance.instance.company = company
            calcMeasureVCInstance.instance.accessibilityLabel = calcMeasureVCInstance.measure
            let pageIndexString = store.measureInfo[calcMeasureVCInstance.measure]!["pageIndex"]!
            self.pages[Int(pageIndexString)!] = calcMeasureVCInstance.instance
        }
        
        // add attribute values to subjective measure pages
        subjectiveMeasureVCInstances.append((self.q1_ViewControllerInst, "q1"))
        subjectiveMeasureVCInstances.append((self.q2_ViewControllerInst, "q2"))
        subjectiveMeasureVCInstances.append((self.q3_ViewControllerInst, "q3"))
        subjectiveMeasureVCInstances.append((self.q4_ViewControllerInst, "q4"))
        subjectiveMeasureVCInstances.append((self.q5_ViewControllerInst, "q5"))
        subjectiveMeasureVCInstances.append((self.q6_ViewControllerInst, "q6"))
        subjectiveMeasureVCInstances.append((self.own_ViewControllerInst, "own"))
        
        for subjectiveMeasureVCInstance in subjectiveMeasureVCInstances {
            subjectiveMeasureVCInstance.instance.company = company
            subjectiveMeasureVCInstance.instance.measure = subjectiveMeasureVCInstance.measure
            subjectiveMeasureVCInstance.instance.accessibilityLabel = subjectiveMeasureVCInstance.measure
            let pageIndexString = store.measureInfo[subjectiveMeasureVCInstance.measure]!["pageIndex"]!
            self.pages[Int(pageIndexString)!] = subjectiveMeasureVCInstance.instance
        }
        
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
}
