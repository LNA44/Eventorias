//
//  AuthView.swift
//  Eventorias
//
//  Created by Ordinateur elena on 01/10/2025.
//

import SwiftUI

struct WelcomeView: View {
    @Binding var flow: RootView.AuthFlow
    
	var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image("Logo Eventorias")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 240, height: 110)
                    .padding(.bottom, 50)
                    .accessibilityLabel("Logo de l'application Eventorias")
                    .accessibilityAddTraits(.isImage)
                    .accessibilityIdentifier("appLogo")
                
                Button(action: {
                    flow = .signUp
                }) {
                    HStack(spacing: 20) {
                        Image(systemName: "envelope.fill")
                            .foregroundColor(.white)
                            .accessibilityHidden(true)
                        
                        Text("Sign up with email")
                            .font(.custom("Inter24pt-SemiBold", size: 16))
                            .foregroundColor(.white)
                            .bold()
                    }
                    .padding(.vertical, 15)
                    .frame(width: 230)
                    .background(Color("ButtonColor"))
                    .cornerRadius(4)
                }
                .accessibilityLabel("S'inscrire avec une adresse e-mail")
                .accessibilityIdentifier("signUpButton")
                
                Button(action: {
                    flow = .signIn
                }) {
                    HStack(spacing: 20) {
                        Image(systemName: "envelope.fill")
                            .foregroundColor(.white)
                            .accessibilityHidden(true)
                        
                        Text("Sign in with email")
                            .font(.custom("Inter24pt-SemiBold", size: 16))
                            .foregroundColor(.white)
                            .bold()
                    }
                    .padding(.vertical, 15)
                    .frame(width: 230)
                    .background(Color("ButtonColor"))
                    .cornerRadius(4)
                    
                }
                .accessibilityLabel("Se connecter avec une adresse e-mail")
                .accessibilityIdentifier("signInButton")
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.top, 150)
        }
        .background(Color.black)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Écran d’accueil de l’application Eventorias")
        .accessibilityHint("Choisissez de vous inscrire ou de vous connecter")
	}
}

#Preview {
    @Previewable @State var flow: RootView.AuthFlow = .welcome
    
    WelcomeView(flow: $flow)
}
