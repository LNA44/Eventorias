//
//  AuthenticationView.swift
//  Eventorias
//
//  Created by Ordinateur elena on 02/10/2025.
//

import SwiftUI

struct AuthenticationView: View {
	@EnvironmentObject var authViewModel: AuthenticationViewModel
	
    var body: some View {
        VStack(spacing: 100) {
            VStack(spacing: 20) {
                VStack {
                    VStack(spacing: 0) {
                        Text("E-mail adress")
                            .foregroundColor(.white)
                            .padding(.top, 10)
                            .padding(.leading, 15)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        CustomTextField(placeholder: "email@example.com", text: $authViewModel.email)
                            .padding(.bottom, 5)
                    }
                    .background(Color("TextfieldColor"))
                    if authViewModel.email.isEmpty {
                        Text("Email is required")
                            .foregroundColor(Color("ButtonColor"))
                            .font(.caption)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                VStack {
                    VStack(spacing: 5) {
                        Text("Password")
                            .foregroundColor(.white)
                            .padding(.top, 10)
                            .padding(.leading, 15)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack {
                            ZStack(alignment: .leading) {
                                if authViewModel.password.isEmpty {
                                    Text("Mot de passe")
                                        .foregroundColor(.gray)
                                        .padding(.leading, 15)
                                }
                                
                                SecureField("", text: $authViewModel.password)
                                    .padding(.leading, 15)
                                    .frame(height: 20)
                                
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                            .background(Color("TextfieldColor"))
                        }
                        .padding(.bottom, 10)
                    }
                    .background(Color("TextfieldColor"))
                    if authViewModel.password.isEmpty {
                        Text("Password is required")
                            .foregroundColor(Color("ButtonColor"))
                            .font(.caption)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    if !authViewModel.isValidPassword() && !authViewModel.password.isEmpty {
                        Text("Password must contain 8 characters, 1 uppercase letter, 1 number, 1 special character")
                            .foregroundColor(Color("ButtonColor"))
                            .font(.caption)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            .padding(.horizontal, 10)
            
            Button(action: {
                authViewModel.signUp()
            }) {
                HStack {
                    Text("Sign in")
                        .foregroundColor(.white)
                        .bold()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color("ButtonColor"))
                .cornerRadius(4)
            }
            .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .alert(isPresented: $authViewModel.isShowingAlert) {
            Alert(
                title: Text("Error"),
                message: Text(authViewModel.errorMessage ?? ""),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

#Preview {
    AuthenticationView()
        .environmentObject(AuthenticationViewModel())
}
