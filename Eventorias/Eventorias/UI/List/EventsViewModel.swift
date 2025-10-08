//
//  EventsViewModel.swift
//  Eventorias
//
//  Created by Ordinateur elena on 02/10/2025.
//

import Foundation

@Observable class EventsViewModel {
    private var service: FirestoreService { FirestoreService.shared }
    var events: [Event] = []
    var errorMessage: String?
    var isSortedAscending: Bool = true
    var isLoading: Bool = false
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
            self.events = try await FirestoreService.shared.fetchEvents(search: search)
            print("Fetched events: \(events)")
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    @MainActor
    func addEvent(name: String, description: String, date: Date, time: Date,
                  location: String, category: String, guests: [String],
                  userProfileImage: String, imageURL: String?) async {
        
        let combinedDateTime = combine(date: date, time: time)
        
        let newEvent = Event(
                id: UUID().uuidString,
                name: name,
                description: description,
                date: combinedDateTime,
                location: location,
                category: category,
                guests: guests,
                userProfileImage: userProfileImage,
                imageURL: imageURL
            )
        
        do {
            try await FirestoreService.shared.addEvent(newEvent)
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
    
    func toggleSorting() {
        isSortedAscending.toggle()
        events.sort { isSortedAscending ? $0.date < $1.date : $0.date > $1.date }
    }
}


