//
//  CustomTextField.swift
//  Eventorias
//
//  Created by Ordinateur elena on 02/10/2025.
//

import SwiftUI

struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    var font: Font = .system(size: 16, weight: .regular, design: .rounded)
    var foregroundColor: Color = .white
    var backgroundColor: Color = Color("TextfieldColor")
    var cornerRadius: CGFloat = 4
    var paddingValue: CGFloat = 15
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(.white)
                    .font(font)
                    .padding(.horizontal, paddingValue)
            }
            
            TextField("", text: $text)
                .font(font)
                .foregroundColor(foregroundColor)
                .padding(.horizontal, paddingValue)
                .frame(height: 30) // fixe la hauteur
        }
        .background(backgroundColor)
        .cornerRadius(cornerRadius)
    }
}
struct CustomTextField_Previews: PreviewProvider {
    @State static var email: String = ""

    static var previews: some View {
        CustomTextField(placeholder: "email@example.com", text: $email)
            .padding()
            .background(Color.black)
            .previewLayout(.sizeThatFits)
    }
}
