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
    @State private var currentStep: Step = .welcome
    
    enum Step {
        case welcome
        case auth
        case main
    }
    
    var body: some View {
        NavigationStack {
            switch currentStep {
            case .welcome:
                WelcomeView() {
                    currentStep = .auth
                }
                .navigationBarHidden(true)
                
            case .auth:
                AuthenticationView(authVM: authVM) {
                    currentStep = .main
                }
                .navigationBarHidden(true)
                
            case .main:
                MainTabView(eventsVM: eventsVM, userVM: userVM)
            }
        }
    }
}
