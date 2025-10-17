//
//  AuthenticationViewModel.swift
//  Eventorias
//
//  Created by Ordinateur elena on 02/10/2025.
//
import SwiftUI
import FirebaseAuth

@Observable class AuthenticationViewModel {
    var email: String = ""
    var password: String = ""
    var errorMessage: String? = nil
    var isShowingAlert: Bool = false
    var isLoading = false
    private var service: FirebaseAuthService { FirebaseAuthService.shared }
    
    func signIn(flow: Binding<RootView.AuthFlow>) async {
        isLoading = true
        defer { isLoading = false }
        
        if service.getCurrentUserID() != nil {
            do {
                try service.signOut()
            } catch {
                isShowingAlert = true
                errorMessage = "Impossible to sign out precedent user : \(error.localizedDescription)"
            }
        }
        
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Email et mot de passe requis"
                   isShowingAlert = true
                   return
        }
        guard isValidEmail() else {
            errorMessage = "Email non valide"
                   isShowingAlert = true
                   return
        }
        guard isValidPassword() else {
            errorMessage = "Mot de passe non valide"
                    isShowingAlert = true
                    return
        }
        do {
            try await service.signIn(email: email, password: password)
            flow.wrappedValue = .main
        } catch let error as AppError.AuthError {
            errorMessage = error.errorDescription
            isShowingAlert = true
        } catch {
            errorMessage = error.localizedDescription
            isShowingAlert = true
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
    
    func signOut() async throws {
        try service.signOut()
    }
}

