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
    
    var pages = [UIViewController](repeating: UIViewController(), count: 14)
    let pageControl = UIPageControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ticker = Utilities.getTickerFromLabel(fullString: measureTicker)
        self.equity = self.store.getEquityByTickerFromStore(ticker: ticker)

        self.dataSource = self
        self.delegate = self
        let measureShortName = Utilities.getMeasureName(fullString: measureTicker)
        let initialPage = getMeasureIndex(measureShortName: measureShortName)
        
        self.edgesForExtendedLayout = []   // prevents view from siding under nav bar
        
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
        
        // set measureTicker on each VC
        ROEaViewControllerInst.measureTicker = "ROEa(\(ticker))"
        EPSiViewControllerInst.measureTicker = "EPSi(\(ticker))"
        EPSvViewControllerInst.measureTicker = "EPSv(\(ticker))"
        BViViewControllerInst.measureTicker = "BVi(\(ticker))"
        DRaViewControllerInst.measureTicker = "DRa(\(ticker))"
        SOrViewControllerInst.measureTicker = "SOr(\(ticker))"
        previousROIViewControllerInst.measureTicker = "previousROI(\(ticker))"
        expectedROIViewControllerInst.measureTicker = "expectedROI(\(ticker))"
        q1ViewControllerInst.measureTicker = "q1(\(ticker))"
        q2ViewControllerInst.measureTicker = "q2(\(ticker))"
        q3ViewControllerInst.measureTicker = "q3(\(ticker))"
        q4ViewControllerInst.measureTicker = "q4(\(ticker))"
        q5ViewControllerInst.measureTicker = "q5(\(ticker))"
        q6ViewControllerInst.measureTicker = "q6(\(ticker))"
        
        // accessibility labels
        expectedROIViewControllerInst.view.accessibilityLabel = "expectedROIViewControllerInst"
        q1ViewControllerInst.view.accessibilityLabel = "q1ViewControllerInst"
        
        // set historicalDataLabel on VC with views that render a chart
        ROEaViewControllerInst.historicalDataLabel = Constants.measureMetadata.historicalDataLabel(.ROEa)()
        EPSiViewControllerInst.historicalDataLabel = Constants.measureMetadata.historicalDataLabel(.EPSi)()
        EPSvViewControllerInst.historicalDataLabel = Constants.measureMetadata.historicalDataLabel(.EPSv)()
        BViViewControllerInst.historicalDataLabel = Constants.measureMetadata.historicalDataLabel(.BVi)()
        DRaViewControllerInst.historicalDataLabel = Constants.measureMetadata.historicalDataLabel(.DRa)()
        SOrViewControllerInst.historicalDataLabel = Constants.measureMetadata.historicalDataLabel(.SOr)()
        
        // set chartLabel on VC with views that render a chart
        ROEaViewControllerInst.chartLabel = Constants.measureMetadata.chartLabel(.ROEa)()
        EPSiViewControllerInst.chartLabel = Constants.measureMetadata.chartLabel(.EPSi)()
        EPSvViewControllerInst.chartLabel = Constants.measureMetadata.chartLabel(.EPSv)()
        BViViewControllerInst.chartLabel = Constants.measureMetadata.chartLabel(.BVi)()
        DRaViewControllerInst.chartLabel = Constants.measureMetadata.chartLabel(.DRa)()
        SOrViewControllerInst.chartLabel = Constants.measureMetadata.chartLabel(.SOr)()
        
        // place the individual viewControllers in the pageViewController
        self.pages[getMeasureIndex(measureShortName: "ROEa")] = ROEaViewControllerInst
        self.pages[getMeasureIndex(measureShortName: "EPSi")] = EPSiViewControllerInst
        self.pages[getMeasureIndex(measureShortName: "EPSv")] = EPSvViewControllerInst
        self.pages[getMeasureIndex(measureShortName: "BVi")] = BViViewControllerInst
        self.pages[getMeasureIndex(measureShortName: "DRa")] = DRaViewControllerInst
        self.pages[getMeasureIndex(measureShortName: "SOr")] = SOrViewControllerInst
        self.pages[getMeasureIndex(measureShortName: "previousROI")] = previousROIViewControllerInst
        self.pages[getMeasureIndex(measureShortName: "expectedROI")] = expectedROIViewControllerInst
        self.pages[getMeasureIndex(measureShortName: "q1")] = q1ViewControllerInst
        self.pages[getMeasureIndex(measureShortName: "q2")] = q2ViewControllerInst
        self.pages[getMeasureIndex(measureShortName: "q3")] = q3ViewControllerInst
        self.pages[getMeasureIndex(measureShortName: "q4")] = q4ViewControllerInst
        self.pages[getMeasureIndex(measureShortName: "q5")] = q5ViewControllerInst
        self.pages[getMeasureIndex(measureShortName: "q6")] = q6ViewControllerInst
        
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
        
        // back button accessibility label
        self.navigationItem.backBarButtonItem?.accessibilityLabel = "backButtonMeasurePageView"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
    
    func getMeasureIndex(measureShortName: String) -> Int {
        switch measureShortName {
        case "ROEa":
            return Constants.measureMetadata.ROEa.index()
        case "EPSi":
            return Constants.measureMetadata.EPSi.index()
        case "EPSv":
            return Constants.measureMetadata.EPSv.index()
        case "BVi":
            return Constants.measureMetadata.BVi.index()
        case "DRa":
            return Constants.measureMetadata.DRa.index()
        case "SOr":
            return Constants.measureMetadata.SOr.index()
        case "previousROI":
            return Constants.measureMetadata.previousROI.index()
        case "expectedROI":
            return Constants.measureMetadata.expectedROI.index()
        case "q1":
            return Constants.measureMetadata.q1.index()
        case "q2":
            return Constants.measureMetadata.q2.index()
        case "q3":
            return Constants.measureMetadata.q3.index()
        case "q4":
            return Constants.measureMetadata.q4.index()
        case "q5":
            return Constants.measureMetadata.q5.index()
        case "q6":
            return Constants.measureMetadata.q6.index()
        default:
            return 0
        }
    }
}
