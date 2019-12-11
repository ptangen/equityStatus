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
    var subjectiveMeasureVCInstances: [(instance: QuestionMeasureViewController, measure: String)] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        self.dataSource = self
        self.delegate = self
        print("measure 4: \(measure)")
        let measureInfo = self.store.measureInfo[self.measure]!
        let initialPage = Int(measureInfo["pageIndex"]!)!
        
        self.edgesForExtendedLayout = []   // prevents view from siding under nav bar
        
        // add attribute values to measure pages
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
        
        // add attribute values to subjective measure pages
        subjectiveMeasureVCInstances.append((self.q1ViewControllerInst, "q1"))
        subjectiveMeasureVCInstances.append((self.q2ViewControllerInst, "q2"))
        subjectiveMeasureVCInstances.append((self.q3ViewControllerInst, "q3"))
        subjectiveMeasureVCInstances.append((self.q4ViewControllerInst, "q4"))
        subjectiveMeasureVCInstances.append((self.q5ViewControllerInst, "q5"))
        subjectiveMeasureVCInstances.append((self.q6ViewControllerInst, "q6"))
        
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
        print("viewWillAppear measure: \(self.measure)")
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let viewControllerIndex = self.pages.index(of: viewController) {
            print("viewControllerIndex pre: \(viewControllerIndex)")
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
            print("viewControllerIndex pre: \(viewControllerIndex)")
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
                print("viewControllerIndex didFinishAnimating: \(viewControllerIndex)")
                self.pageControl.currentPage = viewControllerIndex
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
