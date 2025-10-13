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
                if let userVMAvatarURL = userVM.avatarURL {
                    Image(userVMAvatarURL)
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
        //.ignoresSafeArea()
        .onAppear {
            userVM.loadCurrentUserID()
            userVM.loadUserProfile()
        }
    }
}

#Preview {
    ProfileView(userVM: UserViewModel())
}

