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
      
#if DEBUG
#if targetEnvironment(simulator)
      Task {
          setupFirebaseEmulators()
          await createTestUsers()
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
    
    private func setupFirebaseEmulators() {
        // 🔹 Auth Emulator
        Auth.auth().useEmulator(withHost: "localhost", port: 9099)
        
        // 🔹 Firestore Emulator
        let settings = Firestore.firestore().settings
        settings.host = "localhost:8080"
        settings.isSSLEnabled = false
        Firestore.firestore().settings = settings
        
        // 🔹 Storage Emulator
        let storage = Storage.storage()
        storage.useEmulator(withHost: "localhost", port: 9199) // ✅ avant toute opération
        print("🔹 Storage Emulator configuré")
    }
    
    // MARK: - Création des comptes de test
    private func createTestUsers() async {
        do {
                try await createUser(email: "test@emulator.com", password: "123Elena!", name: "Elena", avatarImage: "Avatar-woman")
                try await createUser(email: "a@gmail.com", password: "123Arthur!", name: "Arthur", avatarImage: "Avatar-man")
                print("✅ Les deux comptes de test ont été créés ou existaient déjà.")
            } catch {
                print("⚠️ Erreur lors de la création des comptes de test : \(error)")
            }
    }
    
    // MARK: - Fonction générique de création d’un compte
    private func createUser(email: String, password: String, name: String, avatarImage: String) async throws {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        let user = result.user
        print("🎉 Compte Auth créé : \(email)")
        
        // 1️⃣ Crée le document Firestore immédiatement
        try await FirestoreService.shared.saveUserToFirestore(uid: user.uid, email: email, name: name, avatarURL: nil)
        
        // 2️⃣ Upload de l'avatar
        if let image = UIImage(named: avatarImage) {
            let avatarURL = try await FirebaseStorageService.shared.uploadAvatarImageAsync(userId: user.uid, image: image)
            
            // 3️⃣ Mise à jour de l'avatarURL
            try await FirestoreService.shared.saveUserToFirestore(uid: user.uid, email: email, name: name, avatarURL: avatarURL)
            print("✅ Avatar uploadé et Firestore mis à jour : \(avatarURL)")
        }
        
        // 4️⃣ Déconnexion
        try Auth.auth().signOut()
        print("🔹 Déconnecté : \(email)")
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
                    //.onAppear {
                      //  delegate.userVM = userVM // ✅ On passe la référence ici
                    //}
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
