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
    var errorMessage: String = ""
    var showError: Bool = false
    
    func loadCurrentUserID() {
        if let uid = authService.getCurrentUserID() {
            self.userID = uid
        } else {
            showError = true
            errorMessage = "Impossible to get the current user ID. Please try again."
        }
    }
    
    func loadUserProfile() {
            guard !userID.isEmpty else {
                showError = true
                errorMessage = "Impossible to load the user profile. Please try again."
                return
            }

        firestoreService.getUserProfile(for: userID) { [weak self] userResult in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                if let userResult = userResult {
                    self.name = userResult.name
                    self.avatarURL = userResult.avatarURL
                    self.email = userResult.email
                } else {
                    self.showError = true
                    self.errorMessage = "Impossible to load the user profile. Please try again."
                }
            }
        }
    }
}
