//
//  AuthenticationVMUnitTests.swift
//  EventoriasTests
//
//  Created by Ordinateur elena on 17/10/2025.
//

import XCTest
@testable import Eventorias
import SwiftUI

@MainActor
final class AuthenticationViewModelTests: XCTestCase {
    
    var viewModel: AuthenticationViewModel!
    var mockAuth: MockAuthServiceForAuthVM!
    
    var authFlow: RootView.AuthFlow = .signIn
    lazy var flowBinding: Binding<RootView.AuthFlow> = {
        Binding<RootView.AuthFlow>(
            get: { [weak self] in self?.authFlow ?? .signIn },
            set: { [weak self] newValue in self?.authFlow = newValue }
        )
    }()
    
    override func setUp() {
        super.setUp()
        mockAuth = MockAuthServiceForAuthVM()
        viewModel = AuthenticationViewModel(service: mockAuth)
    }

    override func tearDown() {
        viewModel = nil
        mockAuth = nil
        super.tearDown()
    }

    func testSignInSuccess() async {
        //Given
        mockAuth.mockCurrentUserID = nil
        viewModel.email = "test@email.com"
        viewModel.password = "Abcdef1!"

        //When
        await viewModel.signIn(flow: flowBinding)

        //Then
        XCTAssertTrue(mockAuth.didSignIn)
        XCTAssertEqual(authFlow, .main)
        XCTAssertFalse(viewModel.isShowingAlert)
        XCTAssertNil(viewModel.errorMessage)
    }

    func testSignInEmptyEmailOrPassword() async {
        //Given
        mockAuth.mockCurrentUserID = nil
        viewModel.email = ""
        viewModel.password = ""

        //When
        await viewModel.signIn(flow: flowBinding)

        //Then
        XCTAssertFalse(mockAuth.didSignIn)
        XCTAssertTrue(viewModel.isShowingAlert)
        XCTAssertEqual(viewModel.errorMessage, "Email and password required")
    }

    func testSignInInvalidEmail() async {
        //Given
        mockAuth.mockCurrentUserID = nil
        viewModel.email = "invalid-email"
        viewModel.password = "Abcdef1!"

        //When
        await viewModel.signIn(flow: flowBinding)

        //Then
        XCTAssertFalse(mockAuth.didSignIn)
        XCTAssertTrue(viewModel.isShowingAlert)
        XCTAssertEqual(viewModel.errorMessage, "Invalid email")
    }

    func testSignInInvalidPassword() async {
        //Given
        mockAuth.mockCurrentUserID = nil
        viewModel.email = "test@email.com"
        viewModel.password = "abcdefg"

        //When
        await viewModel.signIn(flow: flowBinding)

        //Then
        XCTAssertFalse(mockAuth.didSignIn)
        XCTAssertTrue(viewModel.isShowingAlert)
        XCTAssertEqual(viewModel.errorMessage, "Invalid password")
    }

    func testSignInAuthError() async {
        //Given
        mockAuth.mockCurrentUserID = nil
        viewModel.email = "test@email.com"
        viewModel.password = "Abcdef1!"
        mockAuth.shouldThrowSignInError = true

        //When
        await viewModel.signIn(flow: flowBinding)

        //Then
        XCTAssertTrue(viewModel.isShowingAlert)
        XCTAssertEqual(viewModel.errorMessage, AppError.AuthError.userNotCreated.errorDescription)
    }

    func testSignInGenericError() async {
        //Given
        mockAuth.mockCurrentUserID = nil
        viewModel = AuthenticationViewModel(service: FailingAuth())
        viewModel.email = "test@email.com"
        viewModel.password = "Abcdef1!"
        
        //When
        await viewModel.signIn(flow: flowBinding)
        
        //Then
        XCTAssertTrue(viewModel.isShowingAlert)
        XCTAssertEqual(viewModel.errorMessage, NSError(domain: "Test", code: 123).localizedDescription)
    }
    
    func testSignIn_WhenUserAlreadyConnected_ShouldCallSignOutFirst() async {
        mockAuth.mockCurrentUserID = "user123"
        viewModel.email = "test@example.com"
        viewModel.password = "Password1!"
        
        await viewModel.signIn(flow: .constant(.signIn))
        
        XCTAssertTrue(mockAuth.didSignOut, "SignOut doit être appelé quand un utilisateur est déjà connecté.")
        XCTAssertTrue(mockAuth.didSignIn, "SignIn doit être appelé ensuite.")
    }
    
    func testSignIn_WhenSignOutFails_ShowsAlertAndErrorMessage() async {
        // GIVEN
        mockAuth.mockCurrentUserID = "user123"
        mockAuth.shouldThrowSignOutError = true
        viewModel.email = "test@example.com"
        viewModel.password = "Password1!"
        
        // WHEN
        await viewModel.signIn(flow: .constant(.signIn))
        
        // THEN
        XCTAssertTrue(viewModel.isShowingAlert)
        XCTAssertTrue(viewModel.errorMessage?.contains("Impossible to sign out precedent user") ?? false)
        XCTAssertFalse(mockAuth.didSignIn) 
    }
    
    func testSignOutSuccess() async throws {
        //When
        try await viewModel.signOut()
        
        //Then
        XCTAssertTrue(mockAuth.didSignOut)
    }
    
    func testSignOutError() async {
        //Given
        mockAuth.shouldThrowSignOutError = true
        
        //When & Then
        do {
            try await viewModel.signOut()
            XCTFail("Expected error but none thrown")
        } catch {
            let nsError = error as NSError
            XCTAssertEqual(nsError.domain, "Test")
            XCTAssertEqual(nsError.code, 1)
        }
    }
}
