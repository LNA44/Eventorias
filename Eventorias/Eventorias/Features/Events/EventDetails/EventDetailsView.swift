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
    var googleMapsVM: GoogleMapsViewModel
    @Environment(\.dismiss) var dismiss
    @State private var isShareSheetPresented = false
    
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
                    .accessibilityIdentifier("backButton")
                    .accessibilityLabel("Retour")
                    
                    Text(event.name)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .accessibilityIdentifier("eventNameLabel")
                    
                    Spacer()
                }
                .padding()
                .background(Color.black)
                
                ScrollView {
                    VStack {
                        if let imageURL = event.imageURL, let url = URL(string: imageURL) {
                            ZStack {
                                // Fond / placeholder gris ou fallback
                                AsyncImage(url: url) { phase in
                                    switch phase {
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 390, height: 360)
                                            .cornerRadius(8)
                                            .clipped()
                                    case .failure(_), .empty:
                                        Rectangle()
                                            .fill(Color.gray.opacity(0.3))
                                            .frame(width: 390, height: 360)
                                            .cornerRadius(8)
                                            .accessibilityHidden(true)
                                    @unknown default:
                                        EmptyView()
                                    }
                                }

                                AsyncImage(url: url) { phase in
                                    if case .empty = phase {
                                        CustomSpinner(size: 20, lineWidth: 2)
                                    }
                                }
                            }
                        } else {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 390, height: 360)
                                .cornerRadius(8)
                                .accessibilityHidden(true)
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
                                            .font(.custom("Inter28pt-Medium", size: 16))

                                    }
                                    .accessibilityElement(children: .combine)
                                    .accessibilityLabel("Date de l'événement")
                                    
                                    HStack {
                                        Image(systemName: "clock")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 20, height: 20)
                                        
                                        Text(event.date.formattedTime(from: event.date))
                                            .font(.custom("Inter28pt-Medium", size: 16))
                                    }
                                    .accessibilityElement(children: .combine)
                                    .accessibilityLabel("Heure de l'événement")
                                    
                                }
                                Spacer()
                                
                                let avatarURL = eventsVM.getAvatar(for: event.userID)
                                
                                if let urlString = avatarURL, let url = URL(string: urlString) {
                                    ZStack {
                                        // Fond gris circulaire
                                        Circle()
                                            .fill(Color.gray.opacity(0.3))
                                            .frame(width: 70, height: 70)
                                        
                                        AsyncImage(url: url) { phase in
                                            switch phase {
                                            case .success(let image):
                                                image
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 70, height: 70)
                                                    .clipShape(Circle())
                                            case .empty:
                                                CustomSpinner(size: 20, lineWidth: 2)
                                                    .frame(width: 70, height: 70)
                                            case .failure(_):
                                                EmptyView()
                                            @unknown default:
                                                EmptyView()
                                            }
                                        }
                                    }
                                } else {
                                    Circle()
                                        .fill(Color.gray.opacity(0.3))
                                        .frame(width: 70, height: 70)
                                        .accessibilityLabel("Avatar non disponible")
                                }
                            }
                            
                            Text(event.description)
                                .font(.custom("Inter28pt-Regular", size: 14))
                                .accessibilityIdentifier("eventDescriptionLabel")
                                .accessibilityLabel("Description de l'événement")
                                .accessibilityValue(event.description)
                            
                            HStack {
                                Text(event.location)
                                    .font(.custom("Inter28pt-Medium", size: 16))
                                    .accessibilityIdentifier("eventLocationLabel")
                                    .accessibilityLabel("Lieu de l'événement")
                                    .accessibilityValue(event.location)
                                
                                Spacer()
                                
                                StaticMapView(googleMapsVM: googleMapsVM, event: event)
                                    .frame(width: 149, height: 72)
                                    .accessibilityLabel("Carte de localisation")
                            }
                            
                            Button {
                                isShareSheetPresented = true
                            } label: {
                                Label("Partager l'événement", systemImage: "square.and.arrow.up")
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .font(.custom("Inter24pt-SemiBold", size: 16))
                                    .foregroundColor(.white)
                                    .background(Color("ButtonColor"))
                                    .cornerRadius(4)
                            }
                            .accessibilityLabel("Partager l'événement")
                            .accessibilityIdentifier("shareButton")
                            .sheet(isPresented: $isShareSheetPresented) {
                                let textToShare = """
                                        📅 \(event.name)
                                        🗓️ \(event.date.formatted(date: .long, time: .shortened))
                                        📍 \(event.location)
                                        """
                                
                                ActivityController(activityItems: [textToShare])
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
    ), googleMapsVM: GoogleMapsViewModel())
}
