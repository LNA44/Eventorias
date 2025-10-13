//
//  EventDetailsView.swift
//  Eventorias
//
//  Created by Ordinateur elena on 02/10/2025.
//

import SwiftUI

struct EventDetailsView: View {
    var eventsVM: EventsViewModel
    var event: Event
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Barre custom en haut car IOS ne permet plus de mettre dans barre de navigation chevron + titre à gauche
                HStack(spacing: 8) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left") 
                            .resizable()
                            .scaledToFit()
                            .frame(width: 18, height: 18)
                            .foregroundColor(.white)
                    }
                    Text(event.name)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    Spacer()
                }
                .padding()
                .background(Color.black)
                
                ScrollView {
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
                        
                        VStack(spacing: 20) {
                            HStack {
                                VStack(alignment: .leading) {
                                    HStack {
                                        Image("Icon - Today")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .scaleEffect(1.15)
                                            .frame(width: 20, height: 20)
                                        
                                        Text(event.date.formattedDate(from: event.date))
                                    }
                                    HStack {
                                        Image(systemName: "clock")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 20, height: 20)
                                        
                                        Text(event.date.formattedTime(from: event.date))
                                    }
                                    
                                }
                                Spacer()
                                
                                let avatarURL = eventsVM.getAvatar(for: event.userID)
                                
                                if let urlString = avatarURL, let url = URL(string: urlString) {
                                    AsyncImage(url: url) { image in
                                        image
                                            .resizable()
                                            .scaledToFill()
                                    } placeholder: {
                                        Circle()
                                            .fill(Color.gray.opacity(0.3))
                                    }
                                    .frame(width: 70, height: 70)
                                    .clipShape(Circle())
                                } else {
                                    Circle()
                                        .fill(Color.gray.opacity(0.3))
                                        .frame(width: 70, height: 70)
                                }
                            }
                            
                            Text(event.description)
                            
                            HStack {
                                Text(event.location)
                                
                                Spacer()
                                
                                StaticMapView(event: event)
                                    .frame(width: 149, height: 72)
                                    //.cornerRadius(16)
                            }
                            Spacer()
                        }
                        .padding(.top, 15)
                    }
                    .foregroundColor(.white)
                    .padding(10)
                    .navigationBarBackButtonHidden(true)
                    .navigationBarTitleDisplayMode(.inline)
                }
            }
        }
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
    EventDetailsView(eventsVM: EventsViewModel(), event: Event(
            id: "2",
            name: "MusicFestival",
            description: "Un super festival de musique",
            date: Date(),
            location: "Paris",
            category: "Musique",
            guests: ["alice@example.com", "bob@example.com"],
            userID: "17FYd83",
            imageURL: "https://via.placeholder.com/150",
            isUserInvited: false
        ))
}
