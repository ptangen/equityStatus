//
//  BuyTabTests.swift
//  EquityStatus
//
//  Created by Paul Tangen on 2/24/17.
//  Copyright © 2017 Paul Tangen. All rights reserved.
//


import KIF

class UITests : KIFTestCase {

    func clearOutUsernameAndPasswordFields() {
        tester().clearTextFromView(withAccessibilityLabel: "userNameField")
        tester().clearTextFromView(withAccessibilityLabel: "passwordField")
    }

    
    func testSignIn() {
        // sign in with bad credentials
        clearOutUsernameAndPasswordFields()
        tester().enterText("swift3", intoViewWithAccessibilityLabel: "userNameField")
        tester().enterText("123", intoViewWithAccessibilityLabel: "passwordField")
        tester().tapView(withAccessibilityLabel:"signInButton")
        // view does not change, error is displayed through an animation
        tester().waitForView(withAccessibilityLabel: "signInView")
        
        
        // sign in with good credentials
        clearOutUsernameAndPasswordFields()
        tester().enterText("swift3", intoViewWithAccessibilityLabel: "userNameField")
        tester().enterText("1234", intoViewWithAccessibilityLabel: "passwordField")
        tester().tapView(withAccessibilityLabel:"signInButton")
        
        // click the first item on the bar chart
        tester().waitForAbsenceOfView(withAccessibilityLabel: "activityIndicator")
        tester().waitForView(withAccessibilityLabel: "barChartView")
        tester().tapScreen(at: CGPoint(x: 150, y: 220))
        tester().waitForView(withAccessibilityLabel: "equityDetailViewInst")

        tester().tapView(withAccessibilityLabel:"expectedROIResultDesc")
        tester().waitForView(withAccessibilityLabel: "expectedROIViewControllerInst")

        tester().swipeView(withAccessibilityLabel: "expectedROIViewControllerInst", in: .left)
        tester().waitForView(withAccessibilityLabel: "q1ViewControllerInst")
        
        //tester().waitForView(withAccessibilityLabel: "activityIndicator")
        
        // go back up to chart
        tester().tapScreen(at: CGPoint(x: 15, y: 20)) // tap back button
        tester().tapScreen(at: CGPoint(x: 15, y: 20)) // tap back button
        
        // menu > Cancel
        tester().tapView(withAccessibilityLabel: "menuButton")
        tester().tapView(withAccessibilityLabel: "Cancel")
        tester().waitForView(withAccessibilityLabel: "buyView")
        
        // menu sign out
        tester().tapView(withAccessibilityLabel: "menuButton")
        tester().tapView(withAccessibilityLabel: "Sign Out")
        tester().waitForView(withAccessibilityLabel: "signInView")
    }
}
