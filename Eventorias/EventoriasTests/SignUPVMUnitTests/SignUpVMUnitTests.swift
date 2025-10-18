//
//  EventoriasTests.swift
//  EventoriasTests
//
//  Created by Ordinateur elena on 30/09/2025.
//

import XCTest
@testable import Eventorias
import UIKit

@MainActor
final class SignUpVMUnitTests: XCTestCase {
    var viewModel: SignUpViewModel!
    var mockAuth: MockAuthService!
    var mockFirestore: MockFirestoreService!
    var mockStorage: MockStorageService!
    
    override func setUp() {
        super.setUp()
        mockAuth = MockAuthService()
        mockFirestore = MockFirestoreService()
        mockStorage = MockStorageService()
        
        viewModel = SignUpViewModel(
            authService: mockAuth,
            firestoreService: mockFirestore,
            firebaseStorageService: mockStorage
        )
    }
    
    override func tearDown() {
        viewModel = nil
        mockAuth = nil
        mockFirestore = nil
        mockStorage = nil
        super.tearDown()
    }
    
    func testIsValidEmail() {
        viewModel.email = "test@example.com"
        XCTAssertTrue(viewModel.isValidEmail())
        
        viewModel.email = "invalid-email"
        XCTAssertFalse(viewModel.isValidEmail())
    }
    
    // MARK: - Test isValidPassword
    func testIsValidPassword() {
        //When
        viewModel.password = "Abcdef1!"
        
        //Then
        XCTAssertTrue(viewModel.isValidPassword())
        
        //When
        viewModel.password = "abcdef"
        
        //Then
        XCTAssertFalse(viewModel.isValidPassword())
    }
    
    // MARK: - Test createUser success
    func testCreateUserSuccess() async throws {
        //Given
        viewModel.email = "user@test.com"
        viewModel.password = "Abcdef1!"
        viewModel.name = "Jean"
        viewModel.selectedImage = UIImage() // on peut mettre une UIImage vide pour le test
        
        //When
        await viewModel.createUser(
            email: viewModel.email,
            password: viewModel.password,
            name: viewModel.name,
            avatarImage: viewModel.selectedImage
        )
        
        //Then
        XCTAssertTrue(mockAuth.didSignUp)
        XCTAssertTrue(mockAuth.didSignOut)
        XCTAssertTrue(mockFirestore.saveUserCalled)
        XCTAssertTrue(mockFirestore.updateUserAvatarURLCalled)
        
        XCTAssertFalse(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, "")
        XCTAssertFalse(viewModel.isLoading)
    }
    
    // MARK: - Test createUser missing data
    func testCreateUserWithMissingData() async throws {
        //Given
        viewModel.email = ""
        viewModel.password = ""
        viewModel.name = ""
        viewModel.selectedImage = nil
        
        //When
        await viewModel.createUser(
            email: viewModel.email,
            password: viewModel.password,
            name: viewModel.name,
            avatarImage: viewModel.selectedImage
        )
        
        //Then
        XCTAssertFalse(mockAuth.didSignUp)
        XCTAssertFalse(mockAuth.didSignOut)
        XCTAssertFalse(mockFirestore.saveUserCalled)
        XCTAssertFalse(mockFirestore.updateUserAvatarURLCalled)
    }
    
    // MARK: - Test createUser with auth error
    func testCreateUserAuthError() async throws {
        // Simule un erreur dans MockAuth
        //Given
        let failingAuth = FailingAuthService()
        
        viewModel = SignUpViewModel(
            authService: failingAuth,
            firestoreService: mockFirestore,
            firebaseStorageService: mockStorage
        )
        
        viewModel.email = "user@test.com"
        viewModel.password = "Abcdef1!"
        viewModel.name = "Jean"
        viewModel.selectedImage = UIImage()
        
        //When
        await viewModel.createUser(
            email: viewModel.email,
            password: viewModel.password,
            name: viewModel.name,
            avatarImage: viewModel.selectedImage
        )
        
        //Then
        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, AppError.AuthError.userAlreadyCreated.errorDescription)
    }
    
    // MARK: - Test createUser with firestore error
    func testCreateUserGenericError() async throws {
        // Mock Firestore qui échoue
        //Given
        let failingFirestore = FailingFirestoreService()
        
        viewModel = SignUpViewModel(
            authService: mockAuth, 
            firestoreService: failingFirestore,
            firebaseStorageService: mockStorage
        )
        
        viewModel.email = "user@test.com"
        viewModel.password = "Abcdef1!"
        viewModel.name = "Jean"
        viewModel.selectedImage = UIImage()
        
        //When
        await viewModel.createUser(
            email: viewModel.email,
            password: viewModel.password,
            name: viewModel.name,
            avatarImage: viewModel.selectedImage
        )
        
        //Then
        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, "The operation couldn’t be completed. (TestError error 1.)")
    }
}
