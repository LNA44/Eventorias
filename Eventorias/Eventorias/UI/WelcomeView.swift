//
//  AuthView.swift
//  Eventorias
//
//  Created by Ordinateur elena on 01/10/2025.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

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
                
                Button(action: {
                    flow = .signUp
                }) {
                    HStack(spacing: 20) {
                        Image(systemName: "envelope.fill")
                            .foregroundColor(.white)
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
                
                Button(action: {
                    flow = .signIn
                }) {
                    HStack(spacing: 20) {
                        Image(systemName: "envelope.fill")
                            .foregroundColor(.white)
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
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.top, 150)
        }
        .background(Color.black)
	}
}

#Preview {
    @Previewable @State var flow: RootView.AuthFlow = .welcome
    
    WelcomeView(flow: $flow)
}
