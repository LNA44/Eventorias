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
        f.dateStyle = .medium
        f.timeStyle = .none
        return f
    }()
    
    var body: some View {
        HStack {
            if let url = URL(string: event.userProfileImageURL) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 30, height: 30)
                    case .success(let image):
                        image.resizable()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                    case .failure:
                        Image(systemName: "person.circle.fill")
                            .frame(width: 40, height: 40)
                    @unknown default:
                        EmptyView()
                    }
                }
            }
            
            VStack {
                Text(event.name)
                
                Text(formatter.string(from: event.date))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
                        
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
    RowView(event: Event(id: "2", name: "MusicFestival", date: Date(), imageURL: "https://via.placeholder.com/150", userProfileImageURL: "https://via.placeholder.com/50"))
}
