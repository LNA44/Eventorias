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
	var body: some View {
        VStack(spacing: 50) {
			Image("Logo Eventorias")
			
			Button(action: {
				print("Sign in with email tapped")
			}) {
				HStack {
					Image(systemName: "envelope.fill")
						.foregroundColor(.white)
					Text("sign in with email")
						.foregroundColor(.white)
						.bold()
				}
				.padding()
				.frame(width: 250)
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
	WelcomeView()
}
