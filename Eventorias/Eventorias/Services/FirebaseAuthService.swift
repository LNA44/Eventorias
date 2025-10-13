//
//  FirebaseAuthService.swift
//  Eventorias
//
//  Created by Ordinateur elena on 11/10/2025.
//

import Foundation
import FirebaseAuth


class FirebaseAuthService {
    static let shared = FirebaseAuthService()
    
    private init() {}
    
    func signIn(email: String, password: String) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in // permet d'utiliser asyn/await plutot qu'une closureà gérer dans le VM
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let _ = result {
                    continuation.resume(returning: ())
                } else {
                    continuation.resume(throwing: NSError(domain: "FirebaseAuth", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown error"]))
                }
            }
        }
    }
    
    func getCurrentUserID() -> String? {
        return Auth.auth().currentUser?.uid
    }
    
    func getCurrentUserEmail() -> String? {
        return Auth.auth().currentUser?.email
    }
}
