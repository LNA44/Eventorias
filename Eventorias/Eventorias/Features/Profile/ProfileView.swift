//
//  ProfileView.swift
//  Eventorias
//
//  Created by Ordinateur elena on 07/10/2025.
//

import SwiftUI

struct ProfileView: View {
    @Bindable var userVM: UserViewModel
    @State var isToggleOn: Bool = false
    
    var body: some View {
        
        VStack(spacing: 20) {
            HStack {
                Text("User Profile")
                    .font(.custom("Inter24pt-SemiBold", size: 20))
                    .foregroundColor(.white)
                    .accessibilityAddTraits(.isHeader)
                
                Spacer()
                
                if let urlString = userVM.avatarURL, let url = URL(string: urlString) {
                    ZStack {
                        // Cercle gris de fond
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 40, height: 40)
                        
                        // AsyncImage avec image et spinner
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                                    .accessibilityLabel("Avatar de l'utilisateur")
                            case .empty:
                                // Spinner pendant le chargement
                                CustomSpinner(size: 20, lineWidth: 2)
                                    .frame(width: 40, height: 40)
                                    .accessibilityHidden(true)
                            case .failure(_):
                                Circle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 40, height: 40)
                                    .accessibilityLabel("Avatar non disponible")
                            @unknown default:
                                EmptyView()
                            }
                        }
                    }
                } else {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 40, height: 40)
                        .accessibilityLabel("Avatar non disponible")
                }
            }
            .padding(.horizontal, 10)
            VStack(spacing: 0) {
                Text("Name")
                    .font(.custom("Inter28pt-Regular", size: 12))
                    .padding(.top, 10)
                    .padding(.leading, 15)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .accessibilityHidden(true)
                
                Text(userVM.name)
                    .font(.custom("Inter28pt-Regular", size: 16))
                    .padding(.top, 5)
                    .padding(.bottom, 10)
                    .padding(.leading, 15)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .accessibilityLabel("Nom")
                    .accessibilityValue(userVM.name)
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
                    .accessibilityHidden(true)
                
                Text(userVM.email)
                    .font(.custom("Inter28pt-Regular", size: 16))
                    .padding(.top, 5)
                    .padding(.bottom, 10)
                    .padding(.leading, 15)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .accessibilityLabel("E-mail")
                    .accessibilityValue(userVM.email)
            }
            .background(Color("TextfieldColor"))
            .cornerRadius(5)
            .padding(.horizontal, 10)

            HStack(spacing: 10) {
                Toggle("", isOn: $isToggleOn)
                    .labelsHidden()
                    .tint(Color("ButtonColor"))
                    .accessibilityLabel("Notifications")
                    .accessibilityValue(isToggleOn ? "Activées" : "Désactivées")
                
                Text("Notifications")
                    .font(.custom("Inter28pt-Regular", size: 16))
                    .foregroundColor(.white)
                    .accessibilityHidden(true)
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
        .alert(isPresented: $userVM.showError) {
            Alert(
                title: Text("Error"),
                message: Text(userVM.errorMessage),
                dismissButton: .default(Text("OK")) {
                    userVM.showError = false
                }
            )
        }
    }
}

#Preview {
    ProfileView(userVM: UserViewModel())
}

