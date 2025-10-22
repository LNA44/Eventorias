//
//  ListView.swift
//  Eventorias
//
//  Created by Ordinateur elena on 02/10/2025.
//

import SwiftUI

struct ListView: View {
    @Bindable var eventsVM: EventsViewModel
    var googleMapsVM: GoogleMapsViewModel
    var isLoading: Bool = false
    
    var body: some View {
        VStack(spacing: 5) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color("TextfieldColor"))
                    .frame(height: 35)

                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.white)
                        .padding(.leading, 8)
                        .accessibilityHidden(true)

                    TextField(
                        text: $eventsVM.searchText,
                        prompt: Text("Search")
                            .font(.custom("Inter28pt-Regular", size: 16))
                            .foregroundColor(.white)
                    ) {}
                    .foregroundColor(.white)
                    .padding(.vertical, 8)
                    .accessibilityLabel("Recherche d'événements")
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 10)
            
            HStack {
                Menu {
                    Button(action: {
                        eventsVM.sortByDate()
                    }) {
                        Text("By Date")
                            .font(.custom("Inter28pt-Regular", size: 16))
                    }
                    
                    Button(action: {
                        eventsVM.sortByCategory()
                    }) {
                        Text("By Category")
                            .font(.custom("Inter28pt-Regular", size: 16))
                    }
                } label: {
                    HStack(spacing: 4) {
                        Image("Icon - Sort")
                            .foregroundColor(.white)
                        Text("Sorting")
                            .font(.custom("Inter28pt-Regular", size: 16))
                            .foregroundColor(.white)
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 15)
                    .background(Color("TextfieldColor"))
                    .cornerRadius(16)
                }
                .accessibilityLabel("Menu de tri")
                
                Spacer()
            }
            .padding(.horizontal, 10)
            .padding(.bottom, 15)
            
            if eventsVM.errorMessage != "" {
                VStack(spacing: 12) {
                    Circle()
                            .fill(Color("TextfieldColor"))
                            .frame(width: 60, height: 60)

                        Text("!")
                            .font(.custom("Inter28pt-Regular", size: 16))
                            .foregroundColor(.white)
                    
                    Text("Error")
                        .font(.custom("Inter28pt-Regular", size: 16))
                        .foregroundColor(.white)
                    
                    Text(eventsVM.errorMessage)
                        .font(.custom("Inter28pt-Regular", size: 16))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding()
                        .accessibilityLabel("Message d'erreur")
                    
                    Button("Try again") {
                        Task {
                            await eventsVM.fetchEvents()
                        }
                    }
                    .font(.custom("Inter24pt-SemiBold", size: 16))
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color("ButtonColor"))
                    .cornerRadius(12)
                    .accessibilityLabel("Réessayer")
                }
                .frame(maxHeight: .infinity)
                
            } else if eventsVM.events.isEmpty && !isLoading {
                VStack(spacing: 12) {
                    Image(systemName: "calendar.badge.exclamationmark")
                        .font(.system(size: 40))
                        .foregroundColor(.white.opacity(0.7))
                        .accessibilityHidden(true)
                    Text("No events found")
                        .foregroundColor(.white.opacity(0.8))
                        .font(.subheadline)
                        .accessibilityLabel("Aucun événement trouvé")
                }
                .frame(maxHeight: .infinity)
                
            } else if isLoading {
                EmptyView()
                Spacer()
            } else {
                List {
                    ForEach(eventsVM.events) { event in
                        ZStack {
                            RowView(event: event, eventsVM: eventsVM)
                                .accessibilityElement(children: .combine)
                                .accessibilityLabel("\(event.name), \(event.category), \(event.date.formatted())")
                            
                            NavigationLink(destination: EventDetailsView(eventsVM: eventsVM, event: event, googleMapsVM: googleMapsVM)) {
                            }
                            .opacity(0)
                            
                        }
                        .padding(.vertical, 3)
                        .padding(.horizontal, 10)
                    }
                    .background(Color(.black))
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets()) // supprime les marges par défaut
                    .frame(maxWidth: .infinity)  // assure largeur max
                }
                .listStyle(PlainListStyle())
            }
        }
        .background(Color(.black))
        .navigationBarBackButtonHidden(true)
        .onAppear {
            Task {
                await eventsVM.loadAvatars()
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Liste des événements")
    }
}

#Preview {
    ListView(eventsVM: EventsViewModel(), googleMapsVM: GoogleMapsViewModel())
}
