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
    //MARK: -Public properties
    var userID: String = ""
    var name: String = ""
    var email: String = ""
    var avatarURL: String? = nil
    var errorMessage: String = ""
    var showError: Bool = false
    
    //MARK: -Private properties
    private let authService: any FirebaseAuthServicing
    private let firestoreService: FirestoreServicing
    private let firebaseStorageService: FirebaseStorageServicing
    
    //MARK: -Initialization
    init(
        authService: any FirebaseAuthServicing = FirebaseAuthService.shared,
        firestoreService: FirestoreServicing = FirestoreService.shared,
        firebaseStorageService: FirebaseStorageServicing = FirebaseStorageService.shared
    ) {
        self.authService = authService
        self.firestoreService = firestoreService
        self.firebaseStorageService = firebaseStorageService
    }
    
    //MARK: -Methods
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
