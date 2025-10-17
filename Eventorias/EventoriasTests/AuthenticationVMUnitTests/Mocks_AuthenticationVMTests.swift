//
//  Mocks_AuthenticationVMUnitTests.swift
//  EventoriasTests
//
//  Created by Ordinateur elena on 17/10/2025.
//

import Foundation
@testable import Eventorias

class MockAuthServiceForAuthVM: FirebaseAuthServicing {
    var didSignUp = false
    var didSignIn = false
    var didSignOut = false
    
    var shouldThrowSignInError = false
    var shouldThrowSignOutError = false
    
    func signUp(email: String, password: String) async throws -> User {
        didSignUp = true
        return User(id: "mock-uid", email: email, avatarURL: nil, name: "Mock User")
    }
    
    func signIn(email: String, password: String) async throws {
        if shouldThrowSignInError {
            throw AppError.AuthError.userNotCreated
        }
        didSignIn = true
    }
    
    func signOut() throws {
        if shouldThrowSignOutError {
            throw NSError(domain: "Test", code: 1)
        }
        didSignOut = true
    }
    
    func getCurrentUserID() -> String? {
        return nil
    }
    
    func getCurrentUserEmail() -> String? {
        return nil
    }
}

class FailingAuth: MockAuthServiceForAuthVM {
    override func signIn(email: String, password: String) async throws {
        throw NSError(domain: "Test", code: 123)
    }
}
