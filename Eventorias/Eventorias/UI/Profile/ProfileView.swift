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
                    .font(.custom("Inter24pt-SemiBold", size: 20))
                    .foregroundColor(.white)
                
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
            .padding(.horizontal, 10)
            VStack(spacing: 0) {
                Text("Name")
                    .font(.custom("Inter28pt-Regular", size: 12))
                    .padding(.top, 10)
                    .padding(.leading, 15)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(userVM.name)
                    .font(.custom("Inter28pt-Regular", size: 16))
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
                    .font(.custom("Inter28pt-Regular", size: 12))
                    .padding(.top, 10)
                    .padding(.leading, 15)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(userVM.email)
                    .font(.custom("Inter28pt-Regular", size: 16))
                    .padding(.top, 5)
                    .padding(.bottom, 10)
                    .padding(.leading, 15)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .background(Color("TextfieldColor"))
            .cornerRadius(5)
            .padding(.horizontal, 10)

            HStack(spacing: 10) {
                Toggle("", isOn: $isToggleOn)
                    .labelsHidden()
                    .tint(Color("ButtonColor"))
                Text("Notifications")
                    .font(.custom("Inter28pt-Regular", size: 16))
                    .foregroundColor(.white)
            }
            .padding(.leading, 10)
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

