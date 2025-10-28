//
//  FirestoreService.swift
//  Eventorias
//
//  Created by Ordinateur elena on 02/10/2025.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

class FirestoreService: FirestoreServicing {
    static let shared = FirestoreService()
    private let db: Firestore
    
    private init() {
        db = Firestore.firestore()
    }
    
    
    func fetchEvents(search: String = "") async throws -> [Event] {
        var query: Query = db.collection("Event")
        
        if !search.isEmpty { //filtrage coté serveur
            let lowercasedSearch = search.lowercased()
            query = query
                .whereField("name_lowercased", isGreaterThanOrEqualTo: lowercasedSearch) //filtres firestore
                .whereField("name_lowercased", isLessThanOrEqualTo: lowercasedSearch + "\u{f8ff}")
        }
        
        let snapshot = try await query.getDocuments()
        print("Documents trouvés:", snapshot.documents.count)
        
        let events = snapshot.documents.compactMap { doc -> Event? in //transforme tableau firestore en tableau de Event, compactMap ignore les doc mal formés
            let data = doc.data() //récupère le dico [String: Any] du document
            
            guard let name = data["name"] as? String, //Vérif que tous les champs essentiels existent et st du bon type
                  let description = data["description"] as? String,
                  let dateTimestamp = data["date"] as? Timestamp,
                  let location = data["location"] as? String,
                  let category = data["category"] as? String,
                  let userID = data["userID"] as? String
            else {
                return nil
            }
            
            let guests = data["guests"] as? [String] ?? []
            let imageURL = data["imageURL"] as? String
            let date = dateTimestamp.dateValue() // conversion Timestamp firestore → Date

            return Event(
                id: doc.documentID,
                name: name,
                description: description,
                date: date,
                location: location,
                category: category,
                guests: guests,
                userID: userID,
                imageURL: imageURL,
                isUserInvited: false
            )
        }
        print("Events: \(events)")
        return events
    }
    
    func addEvent(_ event: Event) async throws {
        try await db.collection("Event").document(event.id).setData([
            "name": event.name,
            "name_lowercased": event.name.lowercased(), //utile pour recherches sensibles a la casse
            "description": event.description,
            "date": Timestamp(date: event.date),
            "location": event.location,
            "category": event.category,
            "guests": event.guests,
            "userID": event.userID,
            "imageURL": event.imageURL ?? ""
        ])
    }
    
    func convertEmailsToUIDs(emails: [String]) async throws -> ConvertEmailsResult {
        var uids: [String] = []
        var notFound: [String] = []

        for email in emails {
            let query = db.collection("users").whereField("email", isEqualTo: email)
            let snapshot = try await query.getDocuments()
            
            if let doc = snapshot.documents.first {
                uids.append(doc.documentID)
            } else {
                notFound.append(email)
            }
        }
        return ConvertEmailsResult(uids: uids, notFound: notFound)
    }
    
    /*func uploadImage(_ image: UIImage) async throws -> String {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw AppError.FirestoreError.imageError("Impossible to convert image to JPEG")
        }
        let storageRef = Storage.storage().reference().child("eventImages/\(UUID().uuidString).jpg") //cree un sous dossier eventImages
        _ = try await storageRef.putDataAsync(imageData) //envoie les donnees vers firebaseStorage
        return try await storageRef.downloadURL().absoluteString //url publique de l'image stockee, sous forme de string
    }*/
    
    func getUserProfile(for uid: String, completion: @escaping (User?) -> Void) {
        db.collection("users").document(uid).getDocument { snapshot, error in
            if error != nil {
                completion(nil)
                return
            }
            
            guard let data = snapshot?.data(), error == nil else {
                completion(nil)
                return
            }
            
            let name = data["name"] as? String ?? ""
            let email = data["email"] as? String ?? ""
            let avatarURL = data["avatarURL"] as? String
            
            let user = User(id: uid, email: email, avatarURL: avatarURL, name: name)
            completion(user)
        }
    }
    
    func updateUserAvatarURL(for userId: String, url: String, completion: @escaping (Error?) -> Void) {
        db.collection("users").document(userId).updateData([
            "avatarURL": url
        ]) { error in
            completion(error)
        }
    }
    
    func getAvatarURL(for userID: String) async throws -> String? {
        let doc = try await db.collection("users").document(userID).getDocument()
        guard let data = doc.data() else { return nil }
        return data["avatarURL"] as? String
    }
    
    func updateUserAvatarURL(userId: String, url: String) async throws {
        try await db.collection("users").document(userId).setData(["avatarURL": url], merge: true)
    }
    
    func saveUserToFirestore(uid: String, email: String, name: String = "", avatarURL: String? = nil) async throws {
        let userRef = db.collection("users").document(uid)
        let user = User(id: uid, email: email, avatarURL: avatarURL, name: name)
        do {
            try userRef.setData(from: user, merge: true) //permet de mettre à jour le user ds firestore au lieu de tout écraser s'il existe déjà
        } catch {
            throw AppError.FirestoreError.saveUserFailed(underlying: error)
        }
    }
}
