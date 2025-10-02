//
//  AuthenticationViewModel.swift
//  Eventorias
//
//  Created by Ordinateur elena on 02/10/2025.
//

import Foundation
import Combine
import FirebaseAuth

class AuthenticationViewModel: ObservableObject {
	@Published var email: String = ""
	@Published var password: String = ""
    @Published var errorMessage: String? = nil
    @Published var isShowingAlert: Bool = false
	
    func signUp() {
        guard !email.isEmpty, !password.isEmpty else {
            return
        }
        guard isValidEmail() else {
            return
        }
        guard isValidPassword() else {
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.isShowingAlert = true
                    self.errorMessage = error.localizedDescription
                } else {
                    self.isShowingAlert = false
                    self.errorMessage = ""
                }
            }
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

