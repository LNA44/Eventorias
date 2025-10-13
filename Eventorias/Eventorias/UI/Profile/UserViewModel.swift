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
    
    /*init() {
        //utile si utilisateur déjà connecté avant le lancement de l'app (une autre fois)
            if let uid = authService.getCurrentUserID() {
                self.userID = uid
                self.email = authService.getCurrentUserEmail() ?? ""
            } else {
                print("❌ Aucun utilisateur connecté au démarrage")
            }
        }*/
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
    
    func uploadAvatar(image: UIImage) {
        guard !userID.isEmpty else {
                   print("❌ Aucun userID disponible pour uploader l’avatar")
                   return
               }
        
        FirebaseStorageService.shared.uploadAvatarImage(userId: userID, image: image) { result in
            switch result {
            case .success(let url):
                DispatchQueue.main.async {
                    self.avatarURL = url
                }
                print("✅ Avatar uploadé : \(url)")
                self.firestoreService.updateUserAvatarURL(for: self.userID, url: url) { error in
                    if let error = error {
                        print("⚠️ Erreur mise à jour avatarURL dans Firestore : \(error.localizedDescription)")
                    } else {
                        print("✅ avatarURL mise à jour dans Firestore")
                    }
                }
                
            case .failure(let error):
                print("❌ Erreur upload avatar : \(error.localizedDescription)")
            }
        }
    }
}
