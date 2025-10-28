//
//  WelcomeViewUITests.swift
//  EventoriasUITests
//
//  Created by Ordinateur elena on 21/10/2025.
//

import XCTest

final class WelcomeViewUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("-UITestMode")
        app.launch()
    }
    
    func testWelcomeView_UIElementsExist() {
        XCTAssertTrue(app.images["appLogo"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.buttons["signUpButton"].exists)
        XCTAssertTrue(app.buttons["signInButton"].exists)
    }
    
    func testTapSignUpButton_NavigatesToSignUp() {
        let signUpButton = app.buttons["signUpButton"]
        XCTAssertTrue(signUpButton.waitForExistence(timeout: 2))
        signUpButton.tap()
        
        let emailField = app.textFields["emailField"]
        XCTAssertTrue(emailField.waitForExistence(timeout: 3))
    }
    
    func testTapSignInButton_NavigatesToSignIn() {
        let signInButton = app.buttons["signInButton"]
        XCTAssertTrue(signInButton.waitForExistence(timeout: 2))
        signInButton.tap()
        
        let passwordField = app.secureTextFields["passwordField"]
        XCTAssertTrue(passwordField.waitForExistence(timeout: 3))
    }
    
}
