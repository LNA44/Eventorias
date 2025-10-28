//
//  SignUpViewUITests.swift
//  EventoriasUITests
//
//  Created by Ordinateur elena on 22/10/2025.
//

import XCTest

final class SignUpViewUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("-UITestMode")
        app.launch()
    }
    
    func testSignUpView_ElementsExist() {
        let signUpButton = app.buttons["signUpButton"]
        signUpButton.tap()
        XCTAssertTrue(app.textFields["emailField"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.secureTextFields["passwordField"].exists)
        XCTAssertTrue(app.textFields["nameField"].exists)
        XCTAssertTrue(app.buttons["takePictureButton"].exists)
        XCTAssertTrue(app.buttons["choosePictureFromLibraryButton"].exists)
        XCTAssertTrue(app.buttons["createAccountButton"].exists)
    }
    
    func testSignUpView_ValidationErrors() {
        let signUpButton = app.buttons["signUpButton"]
        signUpButton.tap()
        XCTAssertTrue(app.staticTexts["emailErrorLabel"].exists)
        XCTAssertTrue(app.staticTexts["passwordErrorLabel"].exists)
        XCTAssertTrue(app.staticTexts["nameErrorLabel"].exists)
        XCTAssertFalse(app.staticTexts["avatarErrorLabel"].exists)
    }
    
    func testSignUpView_FillFormAndTapSignUp() {
        let signUpButton = app.buttons["signUpButton"]
        signUpButton.tap()
        
        let emailField = app.textFields["emailField"]
        emailField.tap()
        emailField.typeText("test@example.com")
        
        let passwordField = app.secureTextFields["passwordField"]
        passwordField.tap()
        passwordField.typeText("Password123!")
        
        let nameField = app.textFields["nameField"]
        nameField.tap()
        nameField.typeText("Christopher Evans")
        
        // Interactions avec les boutons pour l'image inutile car le VM fournit déjà selectedImage en debug car impossible d'aller ds galerie photos dans UITests
        
        let createAccountButton = app.buttons["createAccountButton"]
        XCTAssertTrue(createAccountButton.exists)
        createAccountButton.tap()
        
        let emailTextField = app.textFields["emailField"]
        XCTAssertTrue(emailTextField.waitForExistence(timeout: 3))

    }
    
}
