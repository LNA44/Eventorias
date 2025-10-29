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
    //MARK: -Public properties
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
    let firestoreService: FirestoreServicing
    let firebaseStorageService: FirebaseStorageServicing
    let authService: FirebaseAuthServicing
    
    //MARK: -Initialization
    init(
        firestoreService: FirestoreServicing = FirestoreService.shared,
        firebaseStorageService: FirebaseStorageServicing = FirebaseStorageService.shared,
        authService: FirebaseAuthServicing = FirebaseAuthService.shared
    ) {
        self.firestoreService = firestoreService
        self.firebaseStorageService = firebaseStorageService
        self.authService = authService
    }
    
    //MARK: -Methods
    func fetchEvents(search: String = "") async {
        do {
            var fetchedEvents = try await firestoreService.fetchEvents(search: search)
            
            if let currentUserID = authService.getCurrentUserID() { 
                //mettre à jour isUserInvited pour chaque event
                for i in fetchedEvents.indices {
                    let invited = fetchedEvents[i].guests.contains(currentUserID)
                            fetchedEvents[i].isUserInvited = invited
                }
                
                //trier pour que les événements invités remontent en haut
                fetchedEvents.sort { $0.isUserInvited && !$1.isUserInvited }
            }
            self.events = fetchedEvents
            await loadAvatars()
        } catch {
            errorMessage = "An error has occurred, please try again later"
        }
    }
    
    func addEvent(name: String, description: String, date: Date, time: Date,
                  location: String, category: String, guests: String,
                imageURL: String?) async {
        let combinedDateTime = combine(date: date, time: time)
        let emails = guests
                .split(separator: ",")
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() }
        do {
            let result = try await firestoreService.convertEmailsToUIDs(emails: emails)
            let guestUIDs = result.uids
            if !result.notFound.isEmpty {
                notFoundEmails = result.notFound
                return
            }
            guard let currentUserID = authService.getCurrentUserID() else {
                showError = true
                errorMessage = "Impossible to get current user"
                return
            }
            guard let combinedDateTime = combinedDateTime else {
                showError = true
                errorMessage = "Impossible to combine date and time"
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
            try await firestoreService.addEvent(newEvent)
            events.append(newEvent)
        } catch {
            showError = true
            errorMessage = error.localizedDescription
        }
    }
    
    func combine(date: Date, time: Date) -> Date? {
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
        
        return calendar.date(from: combinedComponents)
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
    
    func uploadEventImage(_ image: UIImage) async -> String? {
        do {
            let url = try await firebaseStorageService.uploadImage(image)
            return url
        } catch {
            self.errorMessage = error.localizedDescription
            self.showError = true
            return nil
        }
    }
}
