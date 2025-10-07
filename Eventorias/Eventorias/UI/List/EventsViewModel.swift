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
   // var isShowingAlert: Bool = false
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
    
    func addEvent() async {
        let newEvent = Event(
            id: UUID().uuidString,
            name: "Event example",
            date: Date(),
            imageURL: "https://via.placeholder.com/150",
            userProfileImageURL: "https://via.placeholder.com/50"
        )
        do {
            try await FirestoreService.shared.addEvent(newEvent)
            await fetchEvents()
        } catch {
            print("Erreur ajout événement: \(error)")
        }
    }
    
    func toggleSorting() {
        isSortedAscending.toggle()
        events.sort { isSortedAscending ? $0.date < $1.date : $0.date > $1.date }
    }
}


