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
                  let userProfileImage = data["userProfileImage"] as? String
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
                userProfileImage: userProfileImage,
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
            "userProfileImage": event.userProfileImage,
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
}
