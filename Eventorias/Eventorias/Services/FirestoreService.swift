//
//  FirestoreService.swift
//  Eventorias
//
//  Created by Ordinateur elena on 02/10/2025.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

class FirestoreService {
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
                .whereField("name_lowercased", isGreaterThanOrEqualTo: lowercasedSearch)
                .whereField("name_lowercased", isLessThanOrEqualTo: lowercasedSearch + "\u{f8ff}")
        }
        
        let snapshot = try await query.getDocuments()
        print("Documents trouvés:", snapshot.documents.count)
        
        let events = snapshot.documents.compactMap { doc -> Event? in
            let data = doc.data()
            
            guard let name = data["name"] as? String,
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
            let date = dateTimestamp.dateValue() // conversion Timestamp → Date
            
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
        
        return events
    }
    
    func addEvent(_ event: Event) async throws {
        
        try await db.collection("Event").document(event.id).setData([
            "name": event.name,
            "name_lowercased": event.name.lowercased(),
            "description": event.description,
            "date": Timestamp(date: event.date),
            "location": event.location,
            "category": event.category,
            "guests": event.guests,
            "userID": event.userID,
            "imageURL": event.imageURL ?? ""
        ])
    }
    
    func convertEmailsToUIDs(emails: [String]) async -> [String] {
        let db = Firestore.firestore()
        var uids: [String] = []

        for email in emails {
            let query = db.collection("users").whereField("email", isEqualTo: email)
            if let snapshot = try? await query.getDocuments(), let doc = snapshot.documents.first {
                uids.append(doc.documentID) 
            } else {
                print("⚠️ Aucun user trouvé pour email:", email)
            }
        }
        return uids
    }
    
    func uploadImage(_ image: UIImage) async throws -> String {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw NSError(domain: "ImageError", code: 0)
        }
        let storageRef = Storage.storage().reference().child("eventImages/\(UUID().uuidString).jpg")
        try await storageRef.putDataAsync(imageData)
        return try await storageRef.downloadURL().absoluteString
    }
    
    func getUserProfile(for uid: String, completion: @escaping (User?) -> Void) {
        db.collection("users").document(uid).getDocument { snapshot, error in
            guard let data = snapshot?.data(), error == nil else {
                completion(nil)
                return
            }
            
            let name = data["name"] as? String ?? "Utilisateur"
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
    
    func getAvatarURL(for userID: String) async -> String? {
        do {
            let doc = try await Firestore.firestore()
                .collection("users")
                .document(userID)
                .getDocument()
            
            guard let data = doc.data() else { return nil }
            return data["avatarURL"] as? String
        } catch {
            print("Erreur récupération avatarURL: \(error)")
            return nil
        }
    }
}
