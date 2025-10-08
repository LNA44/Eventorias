//
//  MainTabView.swift
//  Eventorias
//
//  Created by Ordinateur elena on 07/10/2025.
//

import SwiftUI

struct MainTabView: View {
    var eventsVM: EventsViewModel
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            EventsContainerView(eventsVM: eventsVM)
                .tabItem {
                    Label("Events", systemImage: "calendar.badge.plus")
                }
                .tag(0)
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
                .tag(1)
        }
        .tint(Color("ButtonColor"))
    }
}
