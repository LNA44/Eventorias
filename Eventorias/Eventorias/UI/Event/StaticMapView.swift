//
//  StaticMapView.swift
//  Eventorias
//
//  Created by Ordinateur elena on 08/10/2025.
//

import SwiftUI

struct StaticMapView: View {
    private var service: GoogleMapsService { GoogleMapsService.shared }
    let event: Event
    
    var body: some View {
        AsyncImage(url: GoogleMapsService.staticMapURL(for: event.location)) { image in
            image
                .resizable()
                .scaledToFit()
        } placeholder: {
            ProgressView()
        }
    }
}

#Preview {
    StaticMapView(event: Event(
        id: "2",
        name: "MusicFestival",
        description: "Un super festival de musique",
        date: Date(),
        location: "Paris",
        category: "Musique",
        guests: ["alice@example.com", "bob@example.com"],
        userProfileImage: "Avatar",
        imageURL: "https://via.placeholder.com/150"
    ))
}
