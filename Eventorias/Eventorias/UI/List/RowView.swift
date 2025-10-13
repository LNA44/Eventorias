//
//  RawView.swift
//  Eventorias
//
//  Created by Ordinateur elena on 02/10/2025.
//

import SwiftUI

struct RowView: View {
    var event: Event
    var eventsVM: EventsViewModel
    let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "MMMM d, yyyy" // Nom complet du mois, jour, année
        f.locale = Locale(identifier: "en_US") // Pour avoir le mois en anglais
        return f
    }()
    
    var body: some View {
        let avatarURL = eventsVM.getAvatar(for: event.userID)
        
        HStack {
            HStack(spacing: 10) {
                HStack {
                    if let urlString = avatarURL, let url = URL(string: urlString) {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            Circle()
                                .fill(Color.gray.opacity(0.3))
                        }
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                    } else {
                        Circle().fill(Color.gray.opacity(0.3))
                            .frame(width: 40, height: 40)
                    }
                    
                    Text(event.name)
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text(event.name)
                        if event.isUserInvited {
                            Text("Invité")
                                .font(.caption2)
                                .bold()
                                .padding(.vertical, 4)
                                .padding(.horizontal, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.blue, lineWidth: 1)
                                )
                        }
                    }
                    Text(event.category)
                    
                    Text(formatter.string(from: event.date))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
                        
            if let imageURL = event.imageURL, let url = URL(string: imageURL) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 60, height: 60)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 136, height: 80)
                            .cornerRadius(8)
                    case .failure:
                        Image(systemName: "photo")
                            .frame(width: 136, height: 68)
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Image(systemName: "photo")
                    .frame(width: 136, height: 80)
            }
        }
        .padding(.leading, 20)
        .padding(.vertical, 10)
        .background(Color("TextfieldColor"))
        .cornerRadius(12)
        .frame(maxWidth: .infinity)
        .foregroundColor(.white)
    }
}

#Preview {
    RowView(event: Event(
            id: "2",
            name: "MusicFestival",
            description: "Un super festival de musique",
            date: Date(),
            location: "Paris",
            category: "Musique",
            guests: ["alice@example.com", "bob@example.com"],
            userID: "1DYN12",
            imageURL: "https://via.placeholder.com/150",
            isUserInvited: false
    ), eventsVM: EventsViewModel())
}
