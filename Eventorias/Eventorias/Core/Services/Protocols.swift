//
//  Protocols.swift
//  Eventorias
//
//  Created by Ordinateur elena on 17/10/2025.
//

import Foundation
import UIKit
import FirebaseAuth

protocol FirestoreServicing {
    func fetchEvents(search: String) async throws -> [Event]
    func addEvent(_ event: Event) async throws
    func convertEmailsToUIDs(emails: [String]) async throws -> ConvertEmailsResult
    func uploadImage(_ image: UIImage) async throws -> String
    func getUserProfile(for uid: String, completion: @escaping (User?) -> Void)
    func updateUserAvatarURL(for userId: String, url: String, completion: @escaping (Error?) -> Void)
    func getAvatarURL(for userID: String) async throws -> String?
    func updateUserAvatarURL(userId: String, url: String) async throws
    func saveUserToFirestore(uid: String, email: String, name: String, avatarURL: String?) async throws
}

protocol GoogleMapsServicing {
    func createMapURL(for address: String) throws -> URL?
}

protocol FirebaseAuthServicing {
    func signUp(email: String, password: String) async throws -> User
    func signIn(email: String, password: String) async throws
    func signOut() throws
    func getCurrentUserID() -> String?
    func getCurrentUserEmail() -> String?
}

protocol FirebaseStorageServicing {
    func uploadAvatarImage(userId: String, image: UIImage) async throws -> String
}
