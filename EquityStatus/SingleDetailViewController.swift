//
//  SingleDetailViewController.swift
//  EquityStatus
//
//  Created by Paul Tangen on 12/30/16.
//  Copyright © 2016 Paul Tangen. All rights reserved.
//

import UIKit

class SingleDetailViewController: UIViewController {
    
    var singleDetailViewInst: SingleDetailView!
    var source: String = String()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func loadView(){
        // hide nav bar on login page
        self.navigationController?.setNavigationBarHidden(true, animated: .init(true))
        
        // load the view into the view controller
        self.singleDetailViewInst = SingleDetailView(frame: CGRect.zero)
        self.singleDetailViewInst.source = self.source
        self.view = self.singleDetailViewInst
        self.navigationController?.navigationBar.backItem?.title = "Back"
        self.title = source
    }
}
