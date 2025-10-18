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
        viewModel.email = ""
        viewModel.password = ""

        //When
        await viewModel.signIn(flow: flowBinding)

        //Then
        XCTAssertFalse(mockAuth.didSignIn)
        XCTAssertTrue(viewModel.isShowingAlert)
        XCTAssertEqual(viewModel.errorMessage, "Email et mot de passe requis")
    }

    func testSignInInvalidEmail() async {
        //Given
        viewModel.email = "invalid-email"
        viewModel.password = "Abcdef1!"

        //When
        await viewModel.signIn(flow: flowBinding)

        //Then
        XCTAssertFalse(mockAuth.didSignIn)
        XCTAssertTrue(viewModel.isShowingAlert)
        XCTAssertEqual(viewModel.errorMessage, "Email non valide")
    }

    func testSignInInvalidPassword() async {
        //Given
        viewModel.email = "test@email.com"
        viewModel.password = "abcdefg"

        //When
        await viewModel.signIn(flow: flowBinding)

        //Then
        XCTAssertFalse(mockAuth.didSignIn)
        XCTAssertTrue(viewModel.isShowingAlert)
        XCTAssertEqual(viewModel.errorMessage, "Mot de passe non valide")
    }

    func testSignInAuthError() async {
        //Given
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
        viewModel = AuthenticationViewModel(service: FailingAuth())
        viewModel.email = "test@email.com"
        viewModel.password = "Abcdef1!"
        
        //When
        await viewModel.signIn(flow: flowBinding)
        
        //Then
        XCTAssertTrue(viewModel.isShowingAlert)
        XCTAssertEqual(viewModel.errorMessage, NSError(domain: "Test", code: 123).localizedDescription)
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
