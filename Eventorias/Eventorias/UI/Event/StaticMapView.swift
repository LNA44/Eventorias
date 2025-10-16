//
//  StaticMapView.swift
//  Eventorias
//
//  Created by Ordinateur elena on 08/10/2025.
//

import SwiftUI

struct StaticMapView: View {
    var googleMapsVM: GoogleMapsViewModel
    let event: Event
    
    var body: some View {
        VStack {
            if let url = googleMapsVM.mapURL {
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
        .onAppear {
            googleMapsVM.loadMap(for: event.location)
        }
    }
}

#Preview {
    StaticMapView(googleMapsVM: GoogleMapsViewModel(), event: Event(
        id: "2",
        name: "MusicFestival",
        description: "Un super festival de musique",
        date: Date(),
        location: "Paris",
        category: "Musique",
        guests: ["alice@example.com", "bob@example.com"],
        userID: "AEE64j3",
        imageURL: "https://via.placeholder.com/150",
        isUserInvited: false
    ))
}
