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
    private var service: FirebaseAuthService { FirebaseAuthService.shared }
    
    func signIn() async {
        guard !email.isEmpty, !password.isEmpty else {
            return
        }
        guard isValidEmail() else {
            return
        }
        guard isValidPassword() else {
            return
        }
        do {
            try await service.signIn(email: email, password: password)
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
}

