//
//  DataCollectionViewController.swift
//  EquityStatus
//
//  Created by Paul Tangen on 11/16/19.
//  Copyright © 2019 Paul Tangen. All rights reserved.
//

import UIKit

class DataCollectionViewController: UIViewController, DataCollectionViewDelegate {
    
    var dataCollectionViewInst = DataCollectionView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataCollectionViewInst.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func loadView(){
        self.dataCollectionViewInst.frame = CGRect(x: 0, y: 0, width: 200, height: 400) //CGRect.zero
        self.dataCollectionViewInst.backgroundColor = UIColor( red: CGFloat(92/255.0), green: CGFloat(203/255.0), blue: CGFloat(207/255.0), alpha: CGFloat(1.0) )
        self.view = self.dataCollectionViewInst
    }
    
    func showAlertMessage(_ message: String) {
        Utilities.showAlertMessage(message, viewControllerInst: self)
    }
}

