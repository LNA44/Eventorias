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
        if let url = GoogleMapsService.staticMapURL(for: event.location) {
            VStack {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(8)
                    case .failure(let error):
                        VStack {
                            Image(systemName: "xmark.octagon")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.red)
                            Text("Erreur chargement carte : \(error.localizedDescription)")
                                .font(.caption)
                                .multilineTextAlignment(.center)
                        }
                    @unknown default:
                        EmptyView()
                    }
                }
            }
        } else {
            Text("Impossible de générer l'URL de la carte")
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
        imageURL: "https://via.placeholder.com/150",
        isUserInvited: false
    ))
}
