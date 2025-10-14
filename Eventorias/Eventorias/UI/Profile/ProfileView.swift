//
//  ProfileView.swift
//  Eventorias
//
//  Created by Ordinateur elena on 07/10/2025.
//

import SwiftUI

struct ProfileView: View {
    var userVM: UserViewModel
    @State var isToggleOn: Bool = false
    
    var body: some View {
        
        VStack(spacing: 20) {
            HStack {
                Text("User Profile")
                    .font(.largeTitle)
                
                Spacer()
                
                if let urlString = userVM.avatarURL, let url = URL(string: urlString) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                    }
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                } else {
                    Circle().fill(Color.gray.opacity(0.3))
                        .frame(width: 40, height: 40)
                }
            }
            VStack(spacing: 0) {
                Text("Name")
                    .padding(.top, 10)
                    .padding(.leading, 15)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(userVM.name)
                    .padding(.top, 5)
                    .padding(.bottom, 10)
                    .padding(.leading, 15)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .background(Color("TextfieldColor"))
            .cornerRadius(5)
            .padding(.horizontal, 10)
         
            VStack(spacing: 0) {
                Text("E-mail")
                    .padding(.top, 10)
                    .padding(.leading, 15)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(userVM.email)
                    .padding(.top, 5)
                    .padding(.bottom, 10)
                    .padding(.leading, 15)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .background(Color("TextfieldColor"))
            .cornerRadius(5)
            .padding(.horizontal, 10)

            HStack {
                Toggle("", isOn: $isToggleOn)
                    .labelsHidden()
                    .tint(Color("ButtonColor"))
                Text("Notifications")
                    .foregroundColor(.white)
            }
            .padding(.leading, 20)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
        }
        .foregroundColor(.white)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .onAppear {
            userVM.loadCurrentUserID()
            userVM.loadUserProfile()
        }
    }
}

#Preview {
    ProfileView(userVM: UserViewModel())
}

