//
//  InfoView.swift
//  EquityStatus
//
//  Created by Paul Tangen on 1/10/17.
//  Copyright © 2017 Paul Tangen. All rights reserved.
//

import UIKit

class InfoView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    let scrollView = UIScrollView()
    let textLabel01 = UILabel()
    let heightOfScrolledContent: CGFloat = 670
    
    override init(frame:CGRect){
        super.init(frame: frame)
        self.layoutPage()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutPage(){
        self.addSubview(self.scrollView)
        self.scrollView.backgroundColor = UIColor.black
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.backgroundColor = UIColor.yellow
        self.scrollView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        self.scrollView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        self.scrollView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        self.scrollView.autoresizingMask = [.flexibleRightMargin, .flexibleLeftMargin, .flexibleBottomMargin]
        self.scrollView.contentSize = CGSize(width: self.bounds.width, height: self.heightOfScrolledContent)

        self.scrollView.addSubview(self.textLabel01)
        self.textLabel01.translatesAutoresizingMaskIntoConstraints = false
        self.textLabel01.widthAnchor.constraint(equalToConstant: 100).isActive = true
        self.textLabel01.numberOfLines = 0
        self.textLabel01.text = "Hello, this is some text that we want to include on the page. It needs to wrap. Hello, this is some text that we want to include on the page. It needs to wrap.Hello, this is some text that we want to include on the page. It needs to wrap.Hello, this is some text that we want to include on the page. It needs to wrap."
        self.textLabel01.backgroundColor = UIColor(named: UIColor.ColorName.blue)
        self.textLabel01.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 20).isActive = true
        self.textLabel01.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor, constant: 180).isActive = true
    }
}
