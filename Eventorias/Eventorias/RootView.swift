//
//  RootView.swift
//  Eventorias
//
//  Created by Ordinateur elena on 07/10/2025.
//

import SwiftUI

struct RootView: View {
    var authVM: AuthenticationViewModel
    var eventsVM: EventsViewModel
    var userVM: UserViewModel
    var signUpVM: SignUpViewModel
    var googleMapsVM: GoogleMapsViewModel
    @State private var flow: AuthFlow = .welcome
    
    enum AuthFlow {
        case welcome
        case signUp
        case signIn
        case main
    }
    
    var body: some View {
        NavigationStack {
            switch flow {
            case .welcome:
                WelcomeView(flow: $flow)
                    .navigationBarHidden(true)
            case .signUp:
                SignUpView(signUpVM: signUpVM, flow: $flow)
                    .navigationBarHidden(true)
            case .signIn:
                AuthenticationView(authVM: authVM, flow: $flow)
                    .navigationBarHidden(true)
            case .main:
                MainTabView(eventsVM: eventsVM, userVM: userVM, googleMapsVM: googleMapsVM)
            }
        }
    }
}
