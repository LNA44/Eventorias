//
//  FirebaseAuthService.swift
//  Eventorias
//
//  Created by Ordinateur elena on 11/10/2025.
//

import Foundation
import FirebaseAuth

class FirebaseAuthService: FirebaseAuthServicing {
    static let shared = FirebaseAuthService()
    private let auth: Auth
    
    private init() {
        auth = Auth.auth()
    }

    func signUp(email: String, password: String) async throws -> User {
        let result = try await auth.createUser(withEmail: email, password: password)
        let firebaseUser = result.user
        return User(
            id: firebaseUser.uid,
            email: firebaseUser.email ?? "",
            avatarURL: nil,
            name: firebaseUser.displayName ?? ""
        )
    }
    
    func signIn(email: String, password: String) async throws {
        try await auth.signIn(withEmail: email, password: password)
    }
    
    func signOut() throws {
        try auth.signOut()
    }
    
    func getCurrentUserID() -> String? {
        return auth.currentUser?.uid
    }
    
    func getCurrentUserEmail() -> String? {
        return auth.currentUser?.email
    }
}
