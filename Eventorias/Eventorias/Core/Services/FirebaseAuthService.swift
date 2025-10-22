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
    
    /*func signUp(email: String, password: String) async throws -> User {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<AuthDataResult, Error>) in
            auth.createUser(withEmail: email, password: password) { result, error in
                if let error = error as NSError? {
                    if AuthErrorCode(rawValue: error.code) == .emailAlreadyInUse {
                        continuation.resume(throwing: AppError.AuthError.userAlreadyCreated)
                    } else {
                        continuation.resume(throwing: error)
                    }
                    return
                }
                if let result = result {
                    continuation.resume(returning: result)
                } else {
                    continuation.resume(throwing: AppError.AuthError.unknown)
                }
            }
        }
    }*/
    
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
    
    /*func signIn(email: String, password: String) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in // permet d'utiliser asyn/await plutot qu'une closureà gérer dans le VM
            auth.signIn(withEmail: email, password: password) { result, error in
                if error != nil  {
                       continuation.resume(throwing: AppError.AuthError.userNotCreated)
                       return
                   }
                   guard result != nil else {
                       continuation.resume(throwing: AppError.AuthError.unknown)
                       return
                   }
                   continuation.resume(returning: ())
            }
        }
    }*/
    
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
