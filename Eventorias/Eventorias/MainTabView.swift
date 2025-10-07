//
//  MainTabView.swift
//  Eventorias
//
//  Created by Ordinateur elena on 07/10/2025.
//

import SwiftUI

struct MainTabView: View {
    var eventsVM: EventsViewModel

    var body: some View {
        TabView {
            ListView(eventsVM: eventsVM)
                .tabItem {
                    Label("Événements", systemImage: "list.bullet")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profil", systemImage: "person.crop.circle")
                }
        }
    }
}
