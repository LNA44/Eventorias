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
                
                VStack {
                    Text("Password")
                        .foregroundColor(.white)
                        .padding(.top, 10)
                        .padding(.leading, 15)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    CustomTextField(placeholder: "", text: $authViewModel.password)
                }
                .background(Color("TextfieldColor"))
            }
            .padding(.horizontal, 10)
            
            Button(action: {
                print("Sign in")
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
    }
}

#Preview {
    AuthenticationView()
        .environmentObject(AuthenticationViewModel())
}
