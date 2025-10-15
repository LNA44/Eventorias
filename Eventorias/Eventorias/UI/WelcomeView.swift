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
    let onNext: () -> Void
    
	var body: some View {
        NavigationStack {
            VStack(spacing: 50) {
                Image("Logo Eventorias")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 240, height: 110)
                
                Button(action: {
                    // Appelle le callback pour passer à l'étape suivante
                    onNext()
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
    WelcomeView(onNext: {})
}
