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
            // Navigation mois
            HStack {
                Button(action: {
                    currentDate = calendar.date(byAdding: .month, value: -1, to: currentDate)!
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Text(monthYearString(from: currentDate))
                    .foregroundColor(.white)
                    .bold()
                
                Spacer()
                
                Button(action: {
                    currentDate = calendar.date(byAdding: .month, value: 1, to: currentDate)!
                }) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal)
            
            // Jours de la semaine
            let weekDays = calendar.shortWeekdaySymbols
            HStack {
                ForEach(weekDays, id: \.self) { day in
                    Text(day)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                        .frame(maxWidth: .infinity)
                }
            }
            
            let maxWeeks = 6
            let rowHeight: CGFloat = 40
            // Grille des jours
            LazyVGrid(columns: columns) {
                ForEach(daysInMonth(), id: \.id) { day in
                    VStack {
                        if day.number == 0 {
                            Color.clear.frame(height: 30) // case vide
                        } else {
                            Text("\(day.number)")
                                .foregroundColor(.white)
                                .frame(width: 30, height: 30)
                                .background(hasEvent(on: day.date) ? Color.green : Color.clear)
                                .clipShape(Circle())
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .onTapGesture {
                        selectedDayEvents = events.filter { calendar.isDate($0.date, inSameDayAs: day.date) }
                        if !selectedDayEvents.isEmpty {
                            showingEventsSheet = true
                        }
                    }
                }
            }
            .frame(height: rowHeight * CGFloat(maxWeeks))
        }
        .background(Color.black.ignoresSafeArea())
        .sheet(isPresented: $showingEventsSheet) {
            ZStack {
                Color.black.ignoresSafeArea() // fond de la sheet

                List(selectedDayEvents) { event in
                    Text(event.name)
                        .foregroundColor(.white) // texte blanc
                        .listRowBackground(Color("TextfieldColor")) // fond cellule
                }
                .scrollContentBackground(.hidden) // empêche le blanc par défaut derrière les cellules
            }
        }
    }
        
    
    private func daysInMonth() -> [Day] {
        guard let range = calendar.range(of: .day, in: .month, for: currentDate) else { return [] }
        var days: [Day] = []
        
        let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate))!
        let weekdayOffset = calendar.component(.weekday, from: firstDayOfMonth) - 1 // jour de la semaine du 1er
        
        // Ajouter des cases vides pour aligner le 1er du mois
        for _ in 0..<weekdayOffset {
            days.append(Day(date: Date(), number: 0)) // number = 0 => case vide
        }
        
        // Jours du mois actuel
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

/*#Preview {
    CalendarView()
}
*/
