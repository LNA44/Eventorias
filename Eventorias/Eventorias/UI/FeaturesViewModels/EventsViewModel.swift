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
    var events: [Event] = []
    var notFoundEmails: [String] = []
    var errorMessage: String = ""
    var showError: Bool = false
    var isSortedAscending: Bool = true
    var avatars: [String: String] = [:]
    var searchText: String = "" {
        didSet {
            Task {
                await fetchEvents(search: searchText)
            }
        }
    }
    private let firestoreService: FirestoreServicing
    private let authService: FirebaseAuthServicing
    
    init(
        firestoreService: FirestoreServicing = FirestoreService.shared,
        authService: FirebaseAuthServicing = FirebaseAuthService.shared
    ) {
        self.firestoreService = firestoreService
        self.authService = authService
    }
    
    @MainActor
    func fetchEvents(search: String = "") async {
        do {
            var fetchedEvents = try await firestoreService.fetchEvents(search: search)
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
            errorMessage = "An error has occurred, please try again later"
        }
    }
    
    @MainActor
    func addEvent(name: String, description: String, date: Date, time: Date,
                  location: String, category: String, guests: String,
                imageURL: String?) async {
        print("🟡 addEvent VM called")
        let combinedDateTime = combine(date: date, time: time)
        print("🟡 About to convert emails")
        let emails = guests
                .split(separator: ",")
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() }
        do {
            let result = try await firestoreService.convertEmailsToUIDs(emails: emails)
            let guestUIDs = result.uids
            notFoundEmails = result.notFound
            print("🟡 Checking current user ID")
            guard let currentUserID = authService.getCurrentUserID() else {
                print("⚠️ Current user ID is nil")
                showError = true
                errorMessage = "Impossible to get current user"
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
            print("🟡 Adding event to Firestore: \(newEvent)")
            try await firestoreService.addEvent(newEvent)
            print("✅ Event added successfully")
            events.append(newEvent)
        } catch {
            print("🔥 Firestore addEvent error:", error.localizedDescription)
            if let nsError = error as NSError? { //a retirer
                print("🔥 Code:", nsError.code, "| Domain:", nsError.domain)//a retirer
            }//a retirer
            showError = true
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
                do {
                    let avatar = try await firestoreService.getAvatarURL(for: event.userID)
                    if let avatar = avatar {
                        avatars[event.userID] = avatar
                    }
                } catch {
                    self.errorMessage = error.localizedDescription
                    self.showError = true
                }
            }
        }
    }
    
    func getAvatar(for userID: String) -> String? {
        return avatars[userID]
    }
    
    @MainActor
    func uploadEventImage(_ image: UIImage) async -> String? {
        do {
            let url = try await firestoreService.uploadImage(image)
            return url
        } catch {
            self.errorMessage = error.localizedDescription
            self.showError = true
            return nil
        }
    }
}

