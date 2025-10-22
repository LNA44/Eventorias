//
//  CustomDatePicker.swift
//  Eventorias
//
//  Created by Ordinateur elena on 08/10/2025.
//

import SwiftUI

struct WhitePicker: UIViewRepresentable {
    @Binding var date: Date
    var mode: UIDatePicker.Mode // .date, .time, ou .dateAndTime

    func makeUIView(context: Context) -> UIDatePicker {
        let picker = UIDatePicker()
        picker.datePickerMode = mode
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "fr_FR")
        picker.setValue(UIColor.white, forKeyPath: "textColor")
        picker.backgroundColor = UIColor(white: 0.1, alpha: 1)
        picker.addTarget(context.coordinator, action: #selector(Coordinator.dateChanged(_:)), for: .valueChanged)
        return picker
    }

    func updateUIView(_ uiView: UIDatePicker, context: Context) {
        uiView.date = date
        uiView.datePickerMode = mode // met à jour si besoin
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject {
        var parent: WhitePicker
        init(_ parent: WhitePicker) { self.parent = parent }
        @objc func dateChanged(_ sender: UIDatePicker) {
            parent.date = sender.date
        }
    }
}
