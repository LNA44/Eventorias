//
//  Mocks_SignUpVMTests.swift
//  EventoriasTests
//
//  Created by Ordinateur elena on 17/10/2025.
//

import Foundation
import UIKit
import FirebaseAuth
@testable import Eventorias

//MARK: -MockAuthService

class MockAuthService: FirebaseAuthServicing {
    var didSignUp = false
    var didSignOut = false
    
    // Valeurs simulées pour tests
    var mockUserID: String = "mock-user-id"
    var mockUserEmail: String = "mock@email.com"
    var mockUserName: String = "Jean"
    
    func signUp(email: String, password: String) async throws -> Eventorias.User {
        didSignUp = true
        let user = Eventorias.User(id: "mock-uid", email: email, name: "Jean")
        return user
    }
    
    func signIn(email: String, password: String) async throws {}
    func signOut() throws { didSignOut = true }
    func getCurrentUserID() -> String? { "mock-uid" }
    func getCurrentUserEmail() -> String? { "mock@email.com" }
}

class FailingAuthService: MockAuthService {
    override func signUp(email: String, password: String) async throws -> Eventorias.User {
           throw AppError.AuthError.userAlreadyCreated
       }
   }

//MARK: -MockFirestoreService
class MockFirestoreService: FirestoreServicing {
    // Flags pour vérifier si les méthodes ont été appelées
    var fetchEventsCalled = false
    var addEventCalled = false
    var convertEmailsCalled = false
    var uploadImageCalled = false
    var getUserProfileCalled = false
    var updateUserAvatarURLCalled = false
    var getAvatarURLCalled = false
    var saveUserCalled = false

    func fetchEvents(search: String) async throws -> [Event] {
        fetchEventsCalled = true
        return [] // retourne une liste vide pour les tests
    }
    
    func addEvent(_ event: Event) async throws {
        addEventCalled = true
    }
    
    func convertEmailsToUIDs(emails: [String]) async throws -> ConvertEmailsResult {
        convertEmailsCalled = true
        return ConvertEmailsResult(uids: [], notFound: emails)
    }
    
    func uploadImage(_ image: UIImage) async throws -> String {
        uploadImageCalled = true
        return "https://mock.url/image.jpg"
    }
    
    func getUserProfile(for uid: String, completion: @escaping (Eventorias.User?) -> Void) { //eventorias.User car sinon swift confond entre struct User et celui de FirebaseAuth
        getUserProfileCalled = true
        let user = Eventorias.User(id: uid, email: "mock@email.com", avatarURL: "https://mock.url/avatar.jpg", name: "Jean")
        completion(user)
    }
    
    func updateUserAvatarURL(for userId: String, url: String, completion: @escaping (Error?) -> Void) {
        updateUserAvatarURLCalled = true
        completion(nil) // pas d'erreur simulée
    }
    
    func getAvatarURL(for userID: String) async throws -> String? {
        getAvatarURLCalled = true
        return "https://mock.url/avatar.jpg"
    }
    
    func updateUserAvatarURL(userId: String, url: String) async throws {
        updateUserAvatarURLCalled = true
    }
    
    func saveUserToFirestore(uid: String, email: String, name: String, avatarURL: String?) async throws {
        saveUserCalled = true
    }
}
class FailingFirestoreService: MockFirestoreService {
        override func saveUserToFirestore(uid: String, email: String, name: String, avatarURL: String?) async throws {
            throw NSError(domain: "TestError", code: 1) // Erreur générique
        }
    }

//MARK: -MockStorageService
final class MockStorageService: FirebaseStorageServicing {
    func uploadAvatarImage(userId: String, image: UIImage) async throws -> String {
        return "https://fakeurl.com/avatar.jpg"
    }
}
