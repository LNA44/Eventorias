//
//  SignUpViewModel.swift
//  Eventorias
//
//  Created by Ordinateur elena on 16/10/2025.
//

import SwiftUI
import FirebaseAuth

@Observable class SignUpViewModel {
    var email: String = ""
    var password: String = ""
    var name: String = ""
    var selectedImage: UIImage?
    var errorMessage: String = ""
    var showError: Bool = false
    var isLoading = false
    private let authService: any FirebaseAuthServicing
    private let firestoreService: FirestoreServicing
    private let firebaseStorageService: FirebaseStorageServicing
    
    init(
        authService: any FirebaseAuthServicing = FirebaseAuthService.shared,
        firestoreService: FirestoreServicing = FirestoreService.shared,
        firebaseStorageService: FirebaseStorageServicing = FirebaseStorageService.shared
    ) {
        self.authService = authService
        self.firestoreService = firestoreService
        self.firebaseStorageService = firebaseStorageService
    }
    
    func createUser(email: String, password: String, name: String, avatarImage: UIImage?) async {
        isLoading = true
        defer { isLoading = false } //meme si ce qui suit échoue, on fera quand meme isLoading = false
        if self.name == "" || self.selectedImage == nil {
            return
        }
        do {
            
            let user = try await authService.signUp(email: email, password: password)
            print("🎉 Compte Auth créé : \(email)")
            
            // 1️⃣ Crée le document Firestore immédiatement
            try await firestoreService.saveUserToFirestore(uid: user.id, email: email, name: name, avatarURL: nil)
            
            // 2️⃣ Upload de l'avatar
            if let image = avatarImage {
                let avatarURL = try await firebaseStorageService.uploadAvatarImage(userId: user.id, image: image)
                try await firestoreService.updateUserAvatarURL(userId: user.id, url: avatarURL)
                
                // 3️⃣ Mise à jour de l'avatarURL
                try await firestoreService.saveUserToFirestore(uid: user.id, email: email, name: name, avatarURL: avatarURL)
            }
            
            // 4️⃣ Déconnexion
            try authService.signOut()
            print("✅ Déconnecté avec succès")
        } catch let error as AppError.AuthError {
            showError = true
            errorMessage = error.errorDescription
        } catch {
            self.errorMessage = error.localizedDescription
            self.showError = true
        }
    }
    
    func isValidEmail() -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    func isValidPassword() -> Bool {
        let passwordRegex = "^(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$&*]).{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
}
