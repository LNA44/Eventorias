//
//  UserVMUnitTests.swift
//  EventoriasTests
//
//  Created by Ordinateur elena on 18/10/2025.
//

import XCTest
@testable import Eventorias

final class UserViewModelTests: XCTestCase {

    var viewModel: UserViewModel!
    var mockAuth: MockFirebaseAuthServiceForUserVM!
    var mockFirestore: MockFirestoreServiceForUserVM!
    var mockStorage: MockFirebaseStorageServiceForUserVM!

    override func setUp() {
        super.setUp()
        mockAuth = MockFirebaseAuthServiceForUserVM()
        mockFirestore = MockFirestoreServiceForUserVM()
        mockStorage = MockFirebaseStorageServiceForUserVM()
        viewModel = UserViewModel(
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

    func testLoadCurrentUserID_Success() {
        // Given
        mockAuth.currentUserID = "12345"

        // When
        viewModel.loadCurrentUserID()

        // Then
        XCTAssertEqual(viewModel.userID, "12345")
        XCTAssertFalse(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, "")
    }

    func testLoadCurrentUserID_Failure() {
        // Given
        mockAuth.currentUserID = nil

        // When
        viewModel.loadCurrentUserID()

        // Then
        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, "Impossible to get current user ID. Please try again.")
    }

    func testLoadUserProfile_Success() {
        // Given
        viewModel.userID = "12345"
        mockFirestore.userProfileToReturn = User(id: "12345", email: "alice@mail.com", avatarURL: "https://avatar.url", name: "Alice")

        let expectation = XCTestExpectation(description: "Wait for async profile load")

        // When
        viewModel.loadUserProfile()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // Then
            XCTAssertEqual(self.viewModel.name, "Alice")
            XCTAssertEqual(self.viewModel.email, "alice@mail.com")
            XCTAssertEqual(self.viewModel.avatarURL, "https://avatar.url")
            XCTAssertFalse(self.viewModel.showError)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func testLoadUserProfile_Failure_NoUserID() {
        // Given
        viewModel.userID = ""

        // When
        viewModel.loadUserProfile()

        // Then
        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, "Impossible to load user profile. Please try again.")
    }

    func testLoadUserProfile_Failure_ProfileNotFound() {
        // Given
        viewModel.userID = "12345"
        mockFirestore.userProfileToReturn = nil

        let expectation = XCTestExpectation(description: "Wait for async profile load")

        // When
        viewModel.loadUserProfile()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // Then
            XCTAssertTrue(self.viewModel.showError)
            XCTAssertEqual(self.viewModel.errorMessage, "Impossible to load user profile. Please try again.")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }
}
