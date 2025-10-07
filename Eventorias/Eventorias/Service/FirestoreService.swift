//
//  FirestoreService.swift
//  Eventorias
//
//  Created by Ordinateur elena on 02/10/2025.
//

import Foundation
import FirebaseFirestore

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
                  let timestamp = data["date"] as? Timestamp,
                  let userProfileImageURL = data["userProfileImageURL"] as? String else {
                return nil
            }
            
            let imageURL = data["imageURL"] as? String
            let date = timestamp.dateValue() // conversion Timestamp → Date
            
            return Event(id: doc.documentID, name: name, date: date, imageURL: imageURL, userProfileImageURL: userProfileImageURL)
        }
        
        return events
    }
    
    func addEvent(_ event: Event) async throws {
        try await db.collection("Events").document(event.id).setData([
            "id": event.id,
            "name": event.name,
            "name_lowercased": event.name.lowercased(), //utile pour la recherche par nom car firebase est sensible à la casse
            "date": Timestamp(date: event.date),
            "imageURL": event.imageURL ?? "",
            "userProfileImageURL": event.userProfileImageURL
        ])
    }
}
