//
//  CalendarView.swift
//  Eventorias
//
//  Created by Ordinateur elena on 07/10/2025.
//

import SwiftUI

struct CalendarView: View {
    @Binding var events: [Event]
    @State private var currentDate = Date()
    @State private var selectedDate: Date? = nil
    @State private var showingEventsSheet = false
    @State private var selectedDayEvents: [Event] = []
    
    private let calendar = Calendar.current
    private let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    currentDate = calendar.date(byAdding: .month, value: -1, to: currentDate)!
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                }
                .accessibilityLabel("Mois précédent")
                
                Spacer()
                
                Text(monthYearString(from: currentDate))
                    .font(.custom("Inter28pt-Medium", size: 16))
                    .foregroundColor(.white)
                    .bold()
                    .accessibilityLabel("Mois actuel")
                
                Spacer()
                
                Button(action: {
                    currentDate = calendar.date(byAdding: .month, value: 1, to: currentDate)!
                }) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.white)
                }
                .accessibilityLabel("Mois suivant")
            }
            .padding(.horizontal)
            
            let weekDays = calendar.shortWeekdaySymbols
            HStack {
                ForEach(weekDays, id: \.self) { day in
                    Text(day)
                        .font(.custom("Inter28pt-Regular", size: 14))
                        .foregroundColor(.white.opacity(0.7))
                        .frame(maxWidth: .infinity)
                        .accessibilityLabel(day)
                }
            }
            
            let maxWeeks = 6
            let rowHeight: CGFloat = 40
            LazyVGrid(columns: columns) {
                ForEach(daysInMonth(), id: \.id) { day in
                    VStack {
                        if day.number == 0 {
                            Color.clear.frame(height: 30)
                        } else {
                            Text("\(day.number)")
                                .font(.custom("Inter28pt-Medium", size: 16))
                                .foregroundColor(.white)
                                .frame(width: 30, height: 30)
                                .background(hasEvent(on: day.date) ? Color.green : Color.clear)
                                .clipShape(Circle())
                                .accessibilityLabel("Jour \(day.number)")
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .onTapGesture {
                        selectedDayEvents = events.filter { calendar.isDate($0.date, inSameDayAs: day.date) }
                        if !selectedDayEvents.isEmpty {
                            showingEventsSheet = true
                        }
                    }
                    .accessibilityAddTraits(.isButton)
                }
            }
            .frame(height: rowHeight * CGFloat(maxWeeks))
        }
        .background(Color.black.ignoresSafeArea())
        .sheet(isPresented: $showingEventsSheet) {
            ZStack {
                Color.black.ignoresSafeArea()

                List(selectedDayEvents) { event in
                    Text(event.name)
                        .font(.custom("Inter28pt-Medium", size: 16))
                        .foregroundColor(.white)
                        .listRowBackground(Color("TextfieldColor"))
                }
                .scrollContentBackground(.hidden)
            }
            .accessibilityElement(children: .contain)
            .accessibilityLabel("Événements du jour")
        }
    }
        
    
    private func daysInMonth() -> [Day] {
        guard let range = calendar.range(of: .day, in: .month, for: currentDate) else { return [] }
        var days: [Day] = []
        
        let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate))!
        let weekdayOffset = calendar.component(.weekday, from: firstDayOfMonth) - 1
        
        for _ in 0..<weekdayOffset {
            days.append(Day(date: Date(), number: 0))
        }
        
        for day in 1...range.count {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: firstDayOfMonth) {
                days.append(Day(date: date, number: day))
            }
        }
        
        return days
    }
    
    private func hasEvent(on date: Date) -> Bool {
        events.contains { calendar.isDate($0.date, inSameDayAs: date) }
    }
    
    private func monthYearString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLLL yyyy"
        return formatter.string(from: date)
    }
}

struct CalendarView_Previews: PreviewProvider {
    @State static var mockEvents: [Event] = [
        Event(
            id: UUID().uuidString,
            name: "Concert de jazz",
            description: "Concert au parc le soir.",
            date: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
            location: "Parc Central",
            category: "Musique",
            guests: ["alice@example.com", "bob@example.com"],
            userID: "user123",
            imageURL: nil,
            isUserInvited: true
        ),
        Event(
            id: UUID().uuidString,
            name: "Conférence iOS",
            description: "Événement sur le développement SwiftUI.",
            date: Calendar.current.date(byAdding: .day, value: 3, to: Date())!,
            location: "Centre Tech",
            category: "Technologie",
            guests: ["dev@example.com"],
            userID: "user123",
            imageURL: nil,
            isUserInvited: false
        ),
        Event(
            id: UUID().uuidString,
            name: "Dîner d'équipe",
            description: "Dîner avec les collègues.",
            date: Calendar.current.date(byAdding: .day, value: 5, to: Date())!,
            location: "Restaurant Le Bon Repas",
            category: "Social",
            guests: ["team@example.com"],
            userID: "user123",
            imageURL: nil,
            isUserInvited: true
        )
    ]
    
    static var previews: some View {
        CalendarView(events: $mockEvents)
            .previewDisplayName("Aperçu calendrier avec événements")
    }
}
