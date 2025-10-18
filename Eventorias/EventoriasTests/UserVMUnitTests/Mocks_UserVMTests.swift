//
//  Mocks_UserVMTests.swift
//  EventoriasTests
//
//  Created by Ordinateur elena on 18/10/2025.
//

import Foundation
import UIKit
@testable import Eventorias

// MARK: - Mock FirebaseAuthService
class MockFirebaseAuthServiceForUserVM: FirebaseAuthServicing {
    var currentUserID: String?
    var currentUserEmail: String?
    var shouldThrowSignInError = false

    func signUp(email: String, password: String) async throws -> User {
        return User(id: "123", email: email, avatarURL: nil, name: "Alice")
    }

    func signIn(email: String, password: String) async throws {
        if shouldThrowSignInError {
            throw NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "Sign in failed"])
        }
    }

    func signOut() throws { }

    func getCurrentUserID() -> String? {
        return currentUserID
    }

    func getCurrentUserEmail() -> String? {
        return currentUserEmail
    }
}

// MARK: - Mock FirestoreService
class MockFirestoreServiceForUserVM: FirestoreServicing {
    var userProfileToReturn: User?
    var shouldThrowError = false

    func fetchEvents(search: String) async throws -> [Event] { [] }
    func addEvent(_ event: Event) async throws { }
    func convertEmailsToUIDs(emails: [String]) async throws -> ConvertEmailsResult {
        return ConvertEmailsResult(uids: [], notFound: [])
    }
    func uploadImage(_ image: UIImage) async throws -> String { "" }

    func getUserProfile(for uid: String, completion: @escaping (User?) -> Void) {
        completion(userProfileToReturn)
    }

    func updateUserAvatarURL(for userId: String, url: String, completion: @escaping (Error?) -> Void) {
        completion(nil)
    }

    func getAvatarURL(for userID: String) async throws -> String? { nil }

    func updateUserAvatarURL(userId: String, url: String) async throws { }

    func saveUserToFirestore(uid: String, email: String, name: String, avatarURL: String?) async throws { }
}

// MARK: - Mock FirebaseStorageService
class MockFirebaseStorageServiceForUserVM: FirebaseStorageServicing {
    var uploadedURL: String = "https://mockurl.com/avatar.png"

    func uploadAvatarImage(userId: String, image: UIImage) async throws -> String {
        return uploadedURL
    }
}
