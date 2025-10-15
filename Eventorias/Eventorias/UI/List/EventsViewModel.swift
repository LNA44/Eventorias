//
//  EventsViewModel.swift
//  Eventorias
//
//  Created by Ordinateur elena on 02/10/2025.
//

import Foundation
import FirebaseAuth
import UIKit

@Observable class EventsViewModel {
    private var service: FirestoreService { FirestoreService.shared }
    var events: [Event] = []
    var errorMessage: String?
    var isSortedAscending: Bool = true
    var isLoading: Bool = false
    var avatars: [String: String] = [:]
    var searchText: String = "" {
        didSet {
            Task {
                await fetchEvents(search: searchText)
            }
        }
    }
    
    @MainActor
    func fetchEvents(search: String = "") async {
        isLoading = true
        do {
            var fetchedEvents = try await service.fetchEvents(search: search)
            print("Fetched events: \(events)")
            
            if let currentUserID = Auth.auth().currentUser?.uid {
                // 1) mettre à jour isUserInvited pour chaque event
                for i in fetchedEvents.indices {
                    let invited = fetchedEvents[i].guests.contains(currentUserID)
                            print("🔍 Event: \(fetchedEvents[i].name)")
                            print("Guests:", fetchedEvents[i].guests)
                            print("CurrentUserID:", currentUserID)
                            print("Is invited:", invited)
                            fetchedEvents[i].isUserInvited = invited
                }
                
                // 2) trier pour que les événements invités remontent en haut
                fetchedEvents.sort { $0.isUserInvited && !$1.isUserInvited }
            }
            self.events = fetchedEvents
            await loadAvatars()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    @MainActor
    func addEvent(name: String, description: String, date: Date, time: Date,
                  location: String, category: String, guests: String,
                imageURL: String?) async {
        print("guests avant enregistrement: \(guests)")
        let combinedDateTime = combine(date: date, time: time)
        
        let emails = guests
                .split(separator: ",")
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() }

        let guestUIDs = await service.convertEmailsToUIDs(emails: emails)
        
        guard let currentUserID = Auth.auth().currentUser?.uid else {
               errorMessage = "Impossible de récupérer l'utilisateur courant."
               return
           }
        
        let newEvent = Event(
                id: UUID().uuidString,
                name: name,
                description: description,
                date: combinedDateTime,
                location: location,
                category: category,
                guests: guestUIDs,
                userID: currentUserID,
                imageURL: imageURL,
                isUserInvited: false
            )
        print("location avant enregistrement : \(newEvent.location)")
        do {
            try await service.addEvent(newEvent)
            events.append(newEvent)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    private func combine(date: Date, time: Date) -> Date {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: time)

        var combinedComponents = DateComponents()
        combinedComponents.year = dateComponents.year
        combinedComponents.month = dateComponents.month
        combinedComponents.day = dateComponents.day
        combinedComponents.hour = timeComponents.hour
        combinedComponents.minute = timeComponents.minute
        combinedComponents.second = timeComponents.second

        return calendar.date(from: combinedComponents) ?? date
    }
    
    func sortByDate(ascending: Bool = true) {
        events.sort {
            ascending ? $0.date < $1.date : $0.date > $1.date
        }
    }
    
    func sortByCategory() {
        events.sort { $0.category < $1.category }
    }
    
    func loadAvatars() async {
        for event in events {
            if avatars[event.userID] == nil {
                let avatar = await service.getAvatarURL(for: event.userID)
                if let avatar = avatar {
                    avatars[event.userID] = avatar
                }
            }
        }
    }
    
    func getAvatar(for userID: String) -> String? {
        return avatars[userID]
    }
    
    @MainActor
    func uploadEventImage(_ image: UIImage) async throws -> String {
        try await service.uploadImage(image)
    }
}


