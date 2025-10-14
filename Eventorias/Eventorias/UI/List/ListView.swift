//
//  ListView.swift
//  Eventorias
//
//  Created by Ordinateur elena on 02/10/2025.
//

import SwiftUI

struct ListView: View {
    @Bindable var eventsVM: EventsViewModel
    
    var body: some View {
        VStack(spacing: 5) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color("TextfieldColor"))
                    .frame(height: 35)

                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.white.opacity(0.7))
                        .padding(.leading, 8)

                    TextField(
                        text: $eventsVM.searchText,
                        prompt: Text("Search").foregroundColor(.white.opacity(0.6))
                    ) {}
                    .foregroundColor(.white)
                    .padding(.vertical, 8)
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
                    }
                    
                    Button(action: {
                        eventsVM.sortByCategory()
                    }) {
                        Text("By Category")
                    }
                } label: {
                    HStack(spacing: 4) {
                        Image("Icon - Sort")
                            .foregroundColor(.white)
                        Text("Sorting")
                            .foregroundColor(.white)
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 15)
                    .background(Color("TextfieldColor"))
                    .cornerRadius(16)
                }
                
                Spacer()
            }
            .padding(.horizontal, 10)
            .padding(.bottom, 15)
            
            if eventsVM.isLoading {
                VStack(spacing: 12) {
                    ProgressView()
                        .tint(.white)
                    Text("Loading events...")
                        .foregroundColor(.white)
                        .font(.subheadline)
                }
                .frame(maxHeight: .infinity)
                
            } else if let error = eventsVM.errorMessage {
                VStack(spacing: 12) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.yellow)
                    Text(error)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    Button("Retry") {
                        Task {
                            await eventsVM.fetchEvents()
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color("ButtonColor"))
                    .cornerRadius(12)
                }
                .frame(maxHeight: .infinity)
                
            } else if eventsVM.events.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "calendar.badge.exclamationmark")
                        .font(.system(size: 40))
                        .foregroundColor(.white.opacity(0.7))
                    Text("No events found")
                        .foregroundColor(.white.opacity(0.8))
                        .font(.subheadline)
                }
                .frame(maxHeight: .infinity)
                
            } else {
                List {
                    ForEach(eventsVM.events) { event in
                        ZStack {
                            RowView(event: event, eventsVM: eventsVM)
                            NavigationLink(destination: EventDetailsView(eventsVM: eventsVM, event: event)) {
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
    }
}

#Preview {
    ListView(eventsVM: EventsViewModel())
}
