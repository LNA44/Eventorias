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
    var service: any FirebaseAuthServicing
    
    init(
        service: any FirebaseAuthServicing = FirebaseAuthService.shared,
    ) {
        self.service = service
    }
    
    func signIn(flow: Binding<RootView.AuthFlow>) async {
        isLoading = true
        defer { isLoading = false }
        
        if service.getCurrentUserID() != nil {
            do {
                try service.signOut()
            } catch {
                isShowingAlert = true
                errorMessage = "Impossible to sign out precedent user : \(error.localizedDescription)"
                return
            }
        }
        
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Email and password required"
            isShowingAlert = true
            return
        }
        guard isValidEmail() else {
            errorMessage = "Invalid email"
            isShowingAlert = true
            return
        }
        guard isValidPassword() else {
            errorMessage = "Invalid password"
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

