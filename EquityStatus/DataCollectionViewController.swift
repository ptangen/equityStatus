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
        self.dataCollectionViewInst.frame = CGRect.zero
        self.view = self.dataCollectionViewInst
    }
    
    func showAlertMessage(_ message: String) {
        Utilities.showAlertMessage(message, viewControllerInst: self)
    }
}

