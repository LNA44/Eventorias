//
//  UserViewModel.swift
//  Eventorias
//
//  Created by Ordinateur elena on 11/10/2025.
//

import Foundation
import FirebaseAuth
import UIKit

@Observable class UserViewModel {
    private var authService: FirebaseAuthService { FirebaseAuthService.shared }
    private var firestoreService: FirestoreService { FirestoreService.shared }
    private var firebaseStorageService: FirebaseStorageService { FirebaseStorageService.shared }

    var userID: String = ""
    var name: String = ""
    var email: String = ""
    var avatarURL: String? = nil

    func loadCurrentUserID() {
            if let uid = authService.getCurrentUserID() {
                self.userID = uid
                print("✅ Utilisateur connecté : \(self.email)")
            } else {
                print("❌ Aucun utilisateur connecté au démarrage")
            }
        }
    
    func loadUserProfile() {
            guard !userID.isEmpty else {
                print("❌ userID vide, impossible de charger le profil")
                return
            }

        firestoreService.getUserProfile(for: userID) { [weak self] userResult in
            DispatchQueue.main.async {
                if let userResult = userResult {
                    self?.name = userResult.name
                    self?.avatarURL = userResult.avatarURL
                    self?.email = userResult.email
                } else {
                    print("⚠️ Impossible de récupérer le profil pour l’utilisateur \(self?.userID ?? "?")")
                }
            }
        }
    }
    
    func uploadAvatar(image: UIImage) async throws -> String {
        guard !userID.isEmpty else {
            print("❌ Aucun userID disponible pour uploader l’avatar")
            throw NSError(domain: "UserViewModel", code: -1, userInfo: [NSLocalizedDescriptionKey: "Aucun userID disponible"])
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            FirebaseStorageService.shared.uploadAvatarImage(userId: userID, image: image) { result in
                switch result {
                case .success(let url):
                    DispatchQueue.main.async {
                        self.avatarURL = url
                    }
                    continuation.resume(returning: url)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
