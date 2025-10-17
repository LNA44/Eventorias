//
//  EventsContainerView.swift
//  Eventorias
//
//  Created by Ordinateur elena on 07/10/2025.
//

import SwiftUI

struct EventsContainerView: View {
    @Bindable var eventsVM: EventsViewModel
    var googleMapsVM: GoogleMapsViewModel
    @State private var showCalendar = false
    @State private var isLoading = true
    
    var body: some View {
        ZStack {
                ZStack(alignment: .bottomTrailing) {
                    VStack(spacing: 0) {
                        Spacer()
                        
                        HStack {
                            Picker("", selection: $showCalendar) {
                                Text("List")
                                    .tag(false)
                                Text("Calendar")
                                    .tag(true)
                            }
                            .font(.custom("Inter28pt-Regular", size: 16))
                            .pickerStyle(.segmented)
                            .padding(.horizontal)
                        }
                        .padding(.vertical, 5)
                        .background(Color("ButtonColor"))
                        .zIndex(1)
                        
                        // Scrollable content
                        ZStack {
                            if showCalendar {
                                CalendarView(events: $eventsVM.events)
                                    .transition(.move(edge: .trailing))
                            } else {
                                ListView(eventsVM: eventsVM, googleMapsVM: googleMapsVM, isLoading: isLoading)
                                    .transition(.move(edge: .leading))
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .animation(.easeInOut, value: showCalendar)
                    }
                    .background(Color.black.ignoresSafeArea())
                    
                    // ✅ Bouton flottant par-dessus
                    NavigationLink(destination: CreateEventView(eventsVM: eventsVM)) {
                        ZStack {
                            Color("ButtonColor")
                                .frame(width: 60, height: 60)
                                .cornerRadius(16)
                                .shadow(radius: 4)
                            Text("+")
                                .font(.system(size: 50, weight: .regular))
                                .foregroundColor(.white)
                                .offset(y: -3)
                        }
                    }
                    .padding(.trailing, 20)
                    .padding(.bottom, 20)
                }
            if isLoading {
                CustomSpinner()
                    .frame(width: 44, height: 44)
            }
        }
        .task {
            isLoading = true
            await eventsVM.fetchEvents()
            isLoading = false
        }
    }
}

/*#Preview {
    EventsContainerView()
}
*/
