//
//  Mock_EventVMUnitTests.swift
//  EventoriasTests
//
//  Created by Ordinateur elena on 18/10/2025.
//

import Foundation
import UIKit
@testable import Eventorias

//MARK: -MockFirestoreServiceForEventsVM
final class MockFirestoreServiceForEventsVM: FirestoreServicing {
    
    // MARK: - Contrôle du comportement
    var shouldThrowFetchError = false
    var shouldThrowAddError = false
    var shouldThrowUploadError = false
    var shouldThrowAvatarError = false
    
    // MARK: - Données à retourner
    var eventsToReturn: [Event] = []
    var convertEmailsResult: ConvertEmailsResult = ConvertEmailsResult(uids: [], notFound: [])
    var imageUploadURL: String?
    var avatarURLToReturn: String?
    
    // MARK: - Suivi des appels
    var didAddEvent: Event?
    var didFetchEvents = false
    var didUploadImage = false
    var didLoadAvatar = false
    
    // MARK: - Méthodes FirestoreServicing
    
    func fetchEvents(search: String) async throws -> [Event] {
        didFetchEvents = true
        if shouldThrowFetchError {
            throw NSError(domain: "FetchError", code: -1)
        }
        return eventsToReturn
    }
    
    func addEvent(_ event: Event) async throws {
        if shouldThrowAddError {
            throw NSError(domain: "AddError", code: -1)
        }
        didAddEvent = event
    }
    
    func convertEmailsToUIDs(emails: [String]) async throws -> ConvertEmailsResult {
        return convertEmailsResult
    }
    
    func uploadImage(_ image: UIImage) async throws -> String {
        didUploadImage = true
        if shouldThrowUploadError {
            throw NSError(domain: "UploadError", code: -1)
        }
        return imageUploadURL ?? "https://mock.com/image.png"
    }
    
    func getUserProfile(for uid: String, completion: @escaping (User?) -> Void) {
        completion(nil)
    }
    
    func updateUserAvatarURL(for userId: String, url: String, completion: @escaping (Error?) -> Void) {
        completion(nil)
    }
    
    func getAvatarURL(for userID: String) async throws -> String? {
        didLoadAvatar = true
        if shouldThrowAvatarError {
            throw NSError(domain: "AvatarError", code: -1)
        }
        return avatarURLToReturn
    }
    
    func updateUserAvatarURL(userId: String, url: String) async throws {}
    
    func saveUserToFirestore(uid: String, email: String, name: String, avatarURL: String?) async throws {}
}

//MARK: -MockAuthServiceForEventsVM
final class MockAuthServiceForEventsVM: FirebaseAuthServicing {
    var currentUserID: String? = "mockUser123"
    var currentUserEmail: String? = "mockuser@example.com"
    var shouldThrowError = false
    
    func signUp(email: String, password: String) async throws -> User {
        if shouldThrowError { throw URLError(.badServerResponse) }
        return User(id: "mockUser123", email: email, avatarURL: nil, name: "Mock User")
    }
    
    func signIn(email: String, password: String) async throws {
        if shouldThrowError { throw URLError(.badServerResponse) }
    }
    
    func signOut() throws {
        if shouldThrowError { throw URLError(.badServerResponse) }
    }
    
    func getCurrentUserID() -> String? {
        return currentUserID
    }
    
    func getCurrentUserEmail() -> String? {
        return currentUserEmail
    }
}
