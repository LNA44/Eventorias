//
//  AuthenticationView.swift
//  Eventorias
//
//  Created by Ordinateur elena on 02/10/2025.
//

import SwiftUI

struct AuthenticationView: View {
    @Bindable var authVM: AuthenticationViewModel
    //var eventsVM: EventsViewModel
    @State private var isSignedIn = false
    let onAuthSuccess: () -> Void
	
    var body: some View {
        VStack(spacing: 100) {
            VStack(spacing: 20) {
                VStack {
                    VStack(spacing: 0) {
                        Text("E-mail adress")
                            .font(.custom("Inter28pt-Regular", size: 12))
                            .foregroundColor(.white)
                            .padding(.top, 10)
                            .padding(.leading, 15)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        CustomTextField(placeholder: "email@example.com", text: $authVM.email)
                            .padding(.bottom, 5)
                    }
                    .background(Color("TextfieldColor"))
                    .cornerRadius(5)
                    
                    if authVM.email.isEmpty {
                        Text("Email is required")
                            .foregroundColor(Color("ButtonColor"))
                            .font(.caption)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                VStack {
                    VStack(spacing: 5) {
                        Text("Password")
                            .font(.custom("Inter28pt-Regular", size: 12))
                            .foregroundColor(.white)
                            .padding(.top, 10)
                            .padding(.leading, 15)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack {
                            ZStack(alignment: .leading) {
                                if authVM.password.isEmpty {
                                    Text("Password")
                                        .font(.custom("Inter28pt-Regular", size: 16))
                                        .foregroundColor(.gray)
                                        .padding(.leading, 15)
                                }
                                
                                SecureField("", text: $authVM.password)
                                    .padding(.leading, 15)
                                    .frame(height: 20)
                                    .font(.custom("Inter28pt-Regular", size: 16))
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                            .background(Color("TextfieldColor"))
                        }
                        .padding(.bottom, 10)
                    }
                    .background(Color("TextfieldColor"))
                    .cornerRadius(5)

                    if authVM.password.isEmpty {
                        Text("Password is required")
                            .font(.custom("Inter28pt-Regular", size: 14))
                            .foregroundColor(Color("ButtonColor"))
                            .font(.caption)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    if !authVM.isValidPassword() && !authVM.password.isEmpty {
                        Text("Password must contain 8 characters, 1 uppercase letter, 1 number, 1 special character")
                            .font(.custom("Inter28pt-Regular", size: 14))
                            .foregroundColor(Color("ButtonColor"))
                            .font(.caption)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            .padding(.horizontal, 10)
            
            Button(action: {
                Task {
                    await authVM.signIn()
                    
                    if authVM.errorMessage == nil {
                        onAuthSuccess()
                    }
                }
            }) {
                HStack {
                    Text("Sign in")
                        .font(.custom("Inter24pt-SemiBold", size: 16))
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
        .alert(isPresented: $authVM.isShowingAlert) {
            Alert(
                title: Text("Error"),
                message: Text(authVM.errorMessage ?? ""),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

#Preview {
    AuthenticationView(authVM: AuthenticationViewModel(), onAuthSuccess: {})
}
