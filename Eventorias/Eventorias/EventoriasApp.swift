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
    var userVM: UserViewModel?
  func application(_ application: UIApplication,
				   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
	FirebaseApp.configure()
      
#if DEBUG
      let testEmail = "test@emulator.com"
      let testPassword = "123Elena!"
      let name = "Elena"
      let avatarImageWoman = "Avatar-woman"
      
      
#if targetEnvironment(simulator)
        // 🔹 Auth Emulator
        Auth.auth().useEmulator(withHost: "localhost", port: 9099)
        
        // 🔹 Firestore Emulator
        let settings = Firestore.firestore().settings
        settings.host = "localhost:8080"
        settings.isSSLEnabled = false
        Firestore.firestore().settings = settings
        
        // Appel de tes fonctions existantes
      Auth.auth().createUser(withEmail: testEmail, password: testPassword) { result, error in
          if let error = error as NSError? {
              if error.code == AuthErrorCode.emailAlreadyInUse.rawValue {
                  print("✅ Compte test déjà existant")
              } else {
                  print("⚠️ Erreur création compte test : \(error.localizedDescription)")
              }
          } else if let user = result?.user {
              print("🎉 Compte test créé avec succès : \(testEmail)")
              Task {
                  do {
                      try await FirestoreService.shared.saveUserToFirestore(uid: user.uid, email: testEmail, name: name, avatarURL: nil)
                      
                      guard let userVM = self.userVM else { return }
                      userVM.userID = user.uid
                      
                      if let image = UIImage(named: avatarImageWoman) {
                          userVM.uploadAvatar(image: image)
                      } else {
                          print("⚠️ Impossible de charger l'image par défaut")
                      }
                      print("✅ Utilisateur enregistré dans Firestore")
                  } catch {
                      print("⚠️ Erreur Firestore : \(error.localizedDescription)")
                  }
              }
          }
      }
      
      Auth.auth().createUser(withEmail: "a@gmail.com", password: "123Arthur!") { result, error in
          if let error = error as NSError? {
              if error.code == AuthErrorCode.emailAlreadyInUse.rawValue {
                  print("✅ Compte test déjà existant")
              } else {
                  print("⚠️ Erreur création compte test : \(error.localizedDescription)")
              }
          } else if let user = result?.user {
              print("🎉 Compte test créé avec succès : \(testEmail)")
              Task {
                  do {
                      try await FirestoreService.shared.saveUserToFirestore(uid: user.uid, email: "a@gmail.com", name: "Arthur", avatarURL: nil)
                      
                      guard let userVM = self.userVM else { return }
                      userVM.userID = user.uid
                      
                      if let image = UIImage(named: "avatar-man") {
                          userVM.uploadAvatar(image: image)
                      } else {
                          print("⚠️ Impossible de charger l'image par défaut")
                      }
                      
                      print("✅ Utilisateur enregistré dans Firestore")
                  } catch {
                      print("⚠️ Erreur Firestore : \(error.localizedDescription)")
                  }
              }
          }
      }

        #else
        // 📱 iPhone réel : Firebase en ligne
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
        #endif
        #endif
      return true
  }
}

@main
struct EventoriasApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State private var authVM: AuthenticationViewModel?
    @State private var eventsVM = EventsViewModel()
    @State private var userVM = UserViewModel()
    
    var body: some Scene {
        WindowGroup {
            if let authVM = authVM {
                RootView(authVM: authVM, eventsVM: eventsVM, userVM: userVM)
                    .onAppear {
                        delegate.userVM = userVM // ✅ On passe la référence ici
                    }
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

extension FirestoreService {
    func saveUserToFirestore(uid: String, email: String, name: String = "", avatarURL: String? = nil) async throws {
            let db = Firestore.firestore()
            let userRef = db.collection("users").document(uid)

            let user = User(
                id: uid,
                email: email,
                avatarURL: avatarURL,
                name: name
            )

            try userRef.setData(from: user, merge: true)
        }
}
