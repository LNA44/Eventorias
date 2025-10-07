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

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
				   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
	FirebaseApp.configure()
      
#if DEBUG
      // Auth Emulator
      Auth.auth().useEmulator(withHost: "localhost", port: 9099)
      
      // Firestore Emulator
      let settings = Firestore.firestore().settings
      settings.host = "localhost:8080"
      settings.isSSLEnabled = false
      Firestore.firestore().settings = settings
      
      let testEmail = "test@emulator.com"
      let testPassword = "123Elena!"
      
      Auth.auth().createUser(withEmail: testEmail, password: testPassword) { result, error in
          if let error = error as NSError? {
              if error.code == AuthErrorCode.emailAlreadyInUse.rawValue {
                  print("✅ Compte test déjà existant")
              } else {
                  print("⚠️ Erreur création compte test : \(error.localizedDescription)")
              }
          } else {
              print("🎉 Compte test créé avec succès : \(testEmail)")
          }
      }
      
      Auth.auth().signIn(withEmail: "testEmail", password: "testPassword") { result, error in
          if let error = error {
              print("Erreur connexion : \(error.localizedDescription)")
          } else {
              print("✅ Connexion réussie avec l'émulateur !")
          }
      }
#endif
      return true
  }
}

@main
struct EventoriasApp: App {
	@UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State private var authVM: AuthenticationViewModel?
    @State private var eventsVM = EventsViewModel()

	var body: some Scene {
		WindowGroup {
            if let authVM = authVM {
                RootView(authVM: authVM, eventsVM: eventsVM)
            } else {
                ProgressView("Loading...")
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.authVM = AuthenticationViewModel()
                        }
                    }
            }
        }
    }
}

