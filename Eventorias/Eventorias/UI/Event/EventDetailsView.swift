//
//  EventDetailsView.swift
//  Eventorias
//
//  Created by Ordinateur elena on 02/10/2025.
//

import SwiftUI

struct EventDetailsView: View {
    var event: Event
    
    var body: some View {
        VStack {
            if let imageURL = event.imageURL, let url = URL(string: imageURL) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView() // loading
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(height: 150)
                                .clipped()
                                .cornerRadius(8)
                        case .failure:
                            Image(systemName: "photo") // fallback si erreur
                                .resizable()
                                .scaledToFit()
                                .frame(height: 150)
                                .foregroundColor(.gray)
                        @unknown default:
                            EmptyView()
                        }
                    }
                } else {
                    Image(systemName: "photo") // si pas d'URL
                        .resizable()
                        .scaledToFit()
                        .frame(height: 150)
                        .foregroundColor(.gray)
                }
            
            VStack {
                HStack {
                    HStack {
                        Image("Icon - Today")
                        Text(event.date.formattedDate(from: event.date))
                    }
                    HStack {
                        Image(systemName: "clock")
                        Text(event.date.formattedTime(from: event.date))
                    }
                    Image(event.userProfileImage)
                        .resizable()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                }
                Text(event.description)
                
                HStack {
                    VStack {
                        Text(event.location)
                        
                    }
                }
            }
        }
        .navigationTitle(event.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

extension Date {
    // Fonctions pour formater la date et l'heure
    func formattedDate(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy" // Nom complet du mois, jour, année
        formatter.locale = Locale(identifier: "en_US") // Anglais US
        return formatter.string(from: date)
    }

    func formattedTime(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a" // h pour 12h, mm pour minutes, a pour AM/PM
        formatter.locale = Locale(identifier: "en_US_POSIX") // pour avoir AM/PM
        return formatter.string(from: date)
    }
}

#Preview {
    EventDetailsView(event: Event(
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
