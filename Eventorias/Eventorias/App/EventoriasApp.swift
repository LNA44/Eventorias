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
  func application(_ application: UIApplication,
				   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
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
    
    init() {
            // 1️⃣ Configurer Firebase en premier
            let isUITestMode = ProcessInfo.processInfo.arguments.contains("-UITestMode")
            if isUITestMode {
                if let filePath = Bundle.main.path(forResource: "GoogleService-Info-Test", ofType: "plist"),
                   let options = FirebaseOptions(contentsOfFile: filePath) {
                    FirebaseApp.configure(options: options)
                } else {
                    fatalError("Impossible de trouver GoogleService-Info-Test.plist")
                }
            } else {
                FirebaseApp.configure()
            }

            // 2️⃣ Créer les ViewModels après Firebase
            _authVM = State(initialValue: AuthenticationViewModel())
            _eventsVM = State(initialValue: EventsViewModel())
            _userVM = State(initialValue: UserViewModel())
            _signUpVM = State(initialValue: SignUpViewModel())
        }

    var body: some Scene {
        WindowGroup {
            if let authVM = authVM, let eventsVM = eventsVM, let userVM = userVM, let signUpVM = signUpVM {
                RootView(authVM: authVM, eventsVM: eventsVM, userVM: userVM, signUpVM: signUpVM, googleMapsVM: googleMapsVM)
            } else {
                ProgressView("Loading...")
                    /*.onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {     //on initialise les VM après que firebaseApp.Configure() ait été init
                            self.authVM = AuthenticationViewModel()
                            self.eventsVM = EventsViewModel()
                            self.userVM = UserViewModel()
                            self.signUpVM = SignUpViewModel()
                        }
                    }*/
            }
         }
    }
}

