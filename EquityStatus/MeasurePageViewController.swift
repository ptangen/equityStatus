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
    var equity: Equity!
    var measureTicker = String()

    
    var pages = [UIViewController]()
    let pageControl = UIPageControl()
    
    func getMeasureIndex(measureShortName: String) -> Int {
        switch measureShortName {
        case "ROEa":
            return Constants.measureMetadata.ROEa.index()
        default:
            return 0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ticker = Utilities.getTickerFromLabel(fullString: measureTicker)
        self.equity = self.store.getEquityByTickerFromStore(ticker: ticker)

        self.dataSource = self
        self.delegate = self
        let measureShortName = Utilities.getMeasureName(fullString: measureTicker)
        let initialPage = getMeasureIndex(measureShortName: measureShortName)
        
        let ROEaViewControllerInst = ROEaViewController()
        let EPSiViewControllerInst = EPSiViewController()
        let EPSvViewControllerInst = EPSvViewController()
        
        // set measureTicker on each VC
        ROEaViewControllerInst.measureTicker = "ROEa(\(ticker))"
        EPSiViewControllerInst.measureTicker = "EPSi(\(ticker))"
        EPSvViewControllerInst.measureTicker = "EPSv(\(ticker))"
        
        // add the individual viewControllers to the pageViewController
        self.pages.append(ROEaViewControllerInst)
        self.pages.append(EPSiViewControllerInst)
        self.pages.append(EPSvViewControllerInst)
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
        //self.navigationController?.isNavigationBarHidden = false
        self.title = "\(self.equity.name.capitalized) (\(self.equity.ticker))"
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
