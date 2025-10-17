//
//  EventoriasApp.swift
//  Eventorias
//
//  Created by Ordinateur elena on 30/09/2025.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class AppDelegate: NSObject, UIApplicationDelegate {
    //var userVM: UserViewModel?
  func application(_ application: UIApplication,
				   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
	FirebaseApp.configure()
      return true
  }
}

@main
struct EventoriasApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State private var authVM: AuthenticationViewModel?
    @State private var eventsVM: EventsViewModel?
    @State private var userVM: UserViewModel?
    @State private var googleMapsVM = GoogleMapsViewModel()
    @State private var signUpVM: SignUpViewModel?

    var body: some Scene {
        WindowGroup {
            if let authVM = authVM, let eventsVM = eventsVM, let userVM = userVM, let signUpVM = signUpVM {
                RootView(authVM: authVM, eventsVM: eventsVM, userVM: userVM, signUpVM: signUpVM, googleMapsVM: googleMapsVM)
            } else {
                ProgressView("Loading...")
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {     //on initialise les VM après que firebaseApp.Configure() ait été init
                            self.authVM = AuthenticationViewModel()
                            self.eventsVM = EventsViewModel()
                            self.userVM = UserViewModel()
                            self.signUpVM = SignUpViewModel()
                        }
                    }
            }
        }
    }
}

