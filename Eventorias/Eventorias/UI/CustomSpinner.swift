//
//  CustomSpinner.swift
//  Eventorias
//
//  Created by Ordinateur elena on 15/10/2025.
//

import SwiftUI

struct CustomSpinner: View {
    var size: CGFloat = 44
    var lineWidth: CGFloat = 4
    var colorLong: Color = .black
    var colorShort: Color = .gray.opacity(0.75)
    @State private var rotation: Angle = .degrees(0)

    var body: some View {
        ZStack {
            // Arc blanc
            Circle()
                .trim(from: 0.03, to: 0.68)
                .stroke(colorLong, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))

            // Arc gris, quasi collé
            Circle()
                .trim(from: 0.73, to: 0.98)
                .stroke(colorShort, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
        }
        .frame(width: size, height: size)
        .rotationEffect(rotation)
        .onAppear {
            withAnimation(.linear(duration: 1.2).repeatForever(autoreverses: false)) {
                rotation = .degrees(360)
            }
        }
    }
}

#Preview {
    CustomSpinner()
}
