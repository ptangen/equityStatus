//
//  BuyTabTests.swift
//  EquityStatus
//
//  Created by Paul Tangen on 2/24/17.
//  Copyright © 2017 Paul Tangen. All rights reserved.
//


import KIF

class LoginTests : KIFTestCase {

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
        // advance to buy view
        tester().waitForView(withAccessibilityLabel: "buyView")
    }
    
}
