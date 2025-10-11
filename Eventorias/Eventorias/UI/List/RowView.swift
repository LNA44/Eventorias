//
//  RawView.swift
//  Eventorias
//
//  Created by Ordinateur elena on 02/10/2025.
//

import SwiftUI

struct RowView: View {
    var event: Event
    let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "MMMM d, yyyy" // Nom complet du mois, jour, année
        f.locale = Locale(identifier: "en_US") // Pour avoir le mois en anglais
        return f
    }()
    
    var body: some View {
        HStack {
            HStack(spacing: 15) {
                Image(event.userProfileImage)
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                
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
            userProfileImage: "Avatar",
            imageURL: "https://via.placeholder.com/150",
            isUserInvited: false
        ))
}
