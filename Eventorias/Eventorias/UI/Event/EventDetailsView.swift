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
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    EventDetailsView(
        event: Event(
            id: "1", name: "MusicFestival",
            date: Date(),
            imageURL: "https://via.placeholder.com/150",
            userProfileImageURL: "https://via.placeholder.com/50"
        )
    )
}
