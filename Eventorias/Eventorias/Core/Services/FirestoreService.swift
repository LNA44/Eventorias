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
        
        if !search.isEmpty {
            let lowercasedSearch = search.lowercased()
            query = query
                .whereField("name_lowercased", isGreaterThanOrEqualTo: lowercasedSearch)
                .whereField("name_lowercased", isLessThanOrEqualTo: lowercasedSearch + "\u{f8ff}")
        }
        
        let snapshot = try await query.getDocuments()
        
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
            let date = dateTimestamp.dateValue()
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
            try userRef.setData(from: user, merge: true) 
        } catch {
            throw AppError.FirestoreError.saveUserFailed(underlying: error)
        }
    }
}
