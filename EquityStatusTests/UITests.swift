//
//  BuyTabTests.swift
//  EquityStatus
//
//  Created by Paul Tangen on 2/24/17.
//  Copyright © 2017 Paul Tangen. All rights reserved.
//


import KIF

class UITests : KIFTestCase {

    func testNavigtion() {
        
        // sign in with bad credentials
        tester().clearTextFromView(withAccessibilityLabel: "userNameField")
        tester().enterText("jim", intoViewWithAccessibilityLabel: "userNameField")
        tester().enterText("712", intoViewWithAccessibilityLabel: "passwordField")
        tester().tapView(withAccessibilityLabel:"signInButton")
        tester().waitForView(withAccessibilityLabel: "signInView")
        
        // sign in with good credentials
        tester().clearTextFromView(withAccessibilityLabel: "userNameField")
        tester().clearTextFromView(withAccessibilityLabel: "passwordField")
        tester().enterText("swift3", intoViewWithAccessibilityLabel: "userNameField")
        tester().enterText("1234", intoViewWithAccessibilityLabel: "passwordField")
        tester().tapView(withAccessibilityLabel:"signInButton")
        
        // open equity from chart
        // click the first item on the bar chart
        tester().waitForAbsenceOfView(withAccessibilityLabel: "activityIndicator")
        tester().waitForView(withAccessibilityLabel: "barChartView")
        tester().tapScreen(at: CGPoint(x: 150, y: 220))
        tester().waitForView(withAccessibilityLabel: "equityDetailViewInst")

        tester().tapView(withAccessibilityLabel:"expectedROIResultDesc")
        tester().waitForView(withAccessibilityLabel: "expectedROIViewControllerInst")

        tester().swipeView(withAccessibilityLabel: "expectedROIViewControllerInst", in: .left)
        tester().waitForView(withAccessibilityLabel: "q1ViewControllerInst")
        
        // go back up to chart
        tester().tapScreen(at: CGPoint(x: 15, y: 20)) // tap back button
        tester().tapScreen(at: CGPoint(x: 15, y: 20)) // tap back button
        
        // open eval tab and show the first equity in the tableview
        tester().tapView(withAccessibilityLabel:"evalTab")
        tester().waitForView(withAccessibilityLabel: "evaluationViewInst")
        let indexPath = IndexPath(row: 0, section: 0)
        tester().waitForCell(at: indexPath, inTableViewWithAccessibilityIdentifier: "evaluationTableViewInst", at: .top)
        tester().tapRow(at: indexPath, inTableViewWithAccessibilityIdentifier: "evaluationTableViewInst")
        tester().waitForView(withAccessibilityLabel: "equityDetailViewInst")
        tester().tapScreen(at: CGPoint(x: 15, y: 20)) // tap back button

        // open sell tab, search for GGG and verify company name in results
        tester().tapView(withAccessibilityLabel:"sellTab")
        tester().waitForView(withAccessibilityLabel: "sellViewInst")
        tester().enterText("GGG", intoViewWithAccessibilityLabel: "searchBar")
        tester().waitForAnimationsToFinish(withTimeout: 2)
        let searchResults = tester().waitForCell(at: indexPath, inTableViewWithAccessibilityIdentifier: "sellTableViewInst")
        tester().expect(searchResults?.textLabel, toContainText: "Graco Inc (GGG)")
        tester().tapScreen(at: CGPoint(x: UIScreen.main.bounds.width-40, y: 50)) // tap cancel to show nav bar
        tester().waitForView(withAccessibilityLabel: "sellViewInst")
        
        // test global nav menu
        tester().tapView(withAccessibilityLabel: "menuButton")
        tester().tapView(withAccessibilityLabel: "Cancel")
        tester().waitForView(withAccessibilityLabel: "sellViewInst")

        tester().tapView(withAccessibilityLabel: "menuButton")
        tester().tapView(withAccessibilityLabel: "Sign Out")
        tester().waitForView(withAccessibilityLabel: "signInView")
    }
}
