//
//  InfoViewController.swift
//  EquityStatus
//
//  Created by Paul Tangen on 1/10/17.
//  Copyright © 2017 Paul Tangen. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {

    var infoViewInst: InfoView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.title = "Information"  // only used in tabBar Controller's didSelect
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func loadView(){
        // load the view into the view controller
        self.infoViewInst = InfoView(frame: CGRect.zero)
        self.view = self.infoViewInst
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
