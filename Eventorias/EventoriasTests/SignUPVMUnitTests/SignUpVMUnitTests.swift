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
        viewModel.password = "Abcdef1!"
        XCTAssertTrue(viewModel.isValidPassword())
        
        viewModel.password = "abcdef"
        XCTAssertFalse(viewModel.isValidPassword())
    }
    
    // MARK: - Test createUser success
    func testCreateUserSuccess() async throws {
        viewModel.email = "user@test.com"
        viewModel.password = "Abcdef1!"
        viewModel.name = "Jean"
        viewModel.selectedImage = UIImage() // on peut mettre une UIImage vide pour le test
        
        await viewModel.createUser(
            email: viewModel.email,
            password: viewModel.password,
            name: viewModel.name,
            avatarImage: viewModel.selectedImage
        )
        
        // Vérifie que les services ont été appelés
        XCTAssertTrue(mockAuth.didSignUp)
        XCTAssertTrue(mockAuth.didSignOut)
        XCTAssertTrue(mockFirestore.saveUserCalled)
        XCTAssertTrue(mockFirestore.updateUserAvatarURLCalled)
        
        // Vérifie que le VM a mis à jour l'état
        XCTAssertFalse(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, "")
        XCTAssertFalse(viewModel.isLoading)
    }
    
    // MARK: - Test createUser missing data
    func testCreateUserWithMissingData() async throws {
        viewModel.email = ""
        viewModel.password = ""
        viewModel.name = ""
        viewModel.selectedImage = nil
        
        await viewModel.createUser(
            email: viewModel.email,
            password: viewModel.password,
            name: viewModel.name,
            avatarImage: viewModel.selectedImage
        )
        
        // Aucune action n'a été faite
        XCTAssertFalse(mockAuth.didSignUp)
        XCTAssertFalse(mockAuth.didSignOut)
        XCTAssertFalse(mockFirestore.saveUserCalled)
        XCTAssertFalse(mockFirestore.updateUserAvatarURLCalled)
    }
    
    // MARK: - Test createUser with auth error
    func testCreateUserAuthError() async throws {
        // Simule un erreur dans MockAuth
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
        
        await viewModel.createUser(
            email: viewModel.email,
            password: viewModel.password,
            name: viewModel.name,
            avatarImage: viewModel.selectedImage
        )
        
        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, AppError.AuthError.userAlreadyCreated.errorDescription)
    }
    
    // MARK: - Test createUser with firestore error
    func testCreateUserGenericError() async throws {
        // Mock Firestore qui échoue
        let failingFirestore = FailingFirestoreService()
        
        viewModel = SignUpViewModel(
            authService: mockAuth, 
            firestoreService: failingFirestore,
            firebaseStorageService: mockStorage
        )
        
        // Remplissage des champs du VM
        viewModel.email = "user@test.com"
        viewModel.password = "Abcdef1!"
        viewModel.name = "Jean"
        viewModel.selectedImage = UIImage()
        
        // Appel de la fonction à tester
        await viewModel.createUser(
            email: viewModel.email,
            password: viewModel.password,
            name: viewModel.name,
            avatarImage: viewModel.selectedImage
        )
        
        // Vérifications
        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, "The operation couldn’t be completed. (TestError error 1.)")
    }
}
