//
//  SignUpView.swift
//  Eventorias
//
//  Created by Ordinateur elena on 16/10/2025.
//

import SwiftUI

struct SignUpView: View {
    @Bindable var signUpVM: SignUpViewModel
    @Binding var flow: RootView.AuthFlow
    @State private var cameraImage: UIImage?
    @State private var showImagePicker = false
    @State private var showCameraPicker = false
    
#if DEBUG
   private var isUITest: Bool {
       ProcessInfo.processInfo.arguments.contains("-UITestMode")
   }
   #endif
    
    var body: some View {
        VStack {
            Text("SignUp")
                .font(.custom("Inter24pt-SemiBold", size: 20))
                .foregroundColor(.white)
                .padding(.bottom, 40)
                .accessibilityLabel("Écran d'inscription")
            
            VStack {
                VStack(spacing: 0) {
                    Text("E-mail adress")
                        .font(.custom("Inter28pt-Regular", size: 12))
                        .foregroundColor(.white)
                        .padding(.top, 10)
                        .padding(.leading, 15)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .accessibilityHidden(true)
                    
                    CustomTextField(placeholder: "email@example.com", text: $signUpVM.email)
                        .padding(.bottom, 5)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .accessibilityLabel("Adresse e-mail")
                        .accessibilityIdentifier("emailField")
                    
                }
                .background(Color("TextfieldColor"))
                .cornerRadius(5)
                
                if signUpVM.email.isEmpty {
                    Text("Email is required")
                        .foregroundColor(Color("ButtonColor"))
                        .font(.caption)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .accessibilityLabel("Erreur : l'adresse e-mail est obligatoire")
                        .accessibilityIdentifier("emailErrorLabel")
                }
            }
            VStack {
                VStack(spacing: 5) {
                    Text("Password")
                        .font(.custom("Inter28pt-Regular", size: 12))
                        .foregroundColor(.white)
                        .padding(.top, 10)
                        .padding(.leading, 15)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .accessibilityHidden(true)
                    
                    VStack {
                        ZStack(alignment: .leading) {
                            if signUpVM.password.isEmpty {
                                Text("Password")
                                    .font(.custom("Inter28pt-Regular", size: 16))
                                    .foregroundColor(.gray)
                                    .padding(.leading, 15)
                                    .accessibilityHidden(true)
                            }
                            
                            SecureField("", text: $signUpVM.password)
                                .padding(.leading, 15)
                                .frame(height: 20)
                                .font(.custom("Inter28pt-Regular", size: 16))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                                .accessibilityLabel("Mot de passe")
                                .accessibilityIdentifier("passwordField")

                        }
                        .background(Color("TextfieldColor"))
                    }
                    .padding(.bottom, 10)
                }
                .background(Color("TextfieldColor"))
                .cornerRadius(5)
                
                if signUpVM.password.isEmpty {
                    Text("Password is required")
                        .font(.custom("Inter28pt-Regular", size: 14))
                        .foregroundColor(Color("ButtonColor"))
                        .font(.caption)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .accessibilityLabel("Erreur : le mot de passe est obligatoire")
                        .accessibilityIdentifier("passwordErrorLabel")
                }
                if !signUpVM.isValidPassword() && !signUpVM.password.isEmpty {
                    Text("Password must contain 8 characters, 1 uppercase letter, 1 number, 1 special character")
                        .font(.custom("Inter28pt-Regular", size: 14))
                        .foregroundColor(Color("ButtonColor"))
                        .font(.caption)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .accessibilityLabel("Erreur : le mot de passe doit contenir huit caractères, une majuscule, un chiffre et un caractère spécial")
                }
            }
            
            VStack(spacing: 0) {
                Text("Full name")
                    .font(.custom("Inter28pt-Regular", size: 12))
                    .foregroundColor(.white)
                    .padding(.top, 10)
                    .padding(.leading, 15)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .accessibilityHidden(true)
                
                CustomTextField(placeholder: "Christopher Evans", text: $signUpVM.name)
                    .padding(.bottom, 5)
                    .accessibilityLabel("Nom complet")
                    .accessibilityIdentifier("nameField")
            }
            .background(Color("TextfieldColor"))
            .cornerRadius(5)
            if signUpVM.name.isEmpty {
                Text("Name is required")
                    .font(.custom("Inter28pt-Regular", size: 14))
                    .foregroundColor(Color("ButtonColor"))
                    .font(.caption)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .accessibilityLabel("Erreur : le nom est obligatoire")
                    .accessibilityIdentifier("nameErrorLabel")
            }
            
            VStack(spacing: 0) {
                HStack(spacing: 10) {
                    Button(action: { showCameraPicker = true }) {
                        HStack {
                            Image(systemName: "camera")
                        }
                        .foregroundColor(.black)
                        .frame(width: 25, height: 25)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(15)
                    }
                    .sheet(isPresented: $showCameraPicker) {
                        CameraPicker(image: $cameraImage)
                    }
                    .accessibilityLabel("Prendre une photo")
                    .accessibilityIdentifier("takePictureButton")
                    
                    Button(action: { showImagePicker = true }) {
                        HStack {
                            Image(systemName: "paperclip")
                                .rotationEffect(.degrees(-45))
                        }
                        .foregroundColor(.white)
                        .frame(width: 25, height: 25)
                        .padding()
                        .background(Color("ButtonColor"))
                        .cornerRadius(15)
                    }
                    .sheet(isPresented: $showImagePicker) {
                        ImagePicker(selectedImage: $signUpVM.selectedImage) //modif
                    }
                    .accessibilityLabel("Choisir une photo depuis la galerie")
                    .accessibilityIdentifier("choosePictureFromLibraryButton")
                }
                .padding(.top, 30)
                if signUpVM.selectedImage == nil {
                    Text("Choose an avatar")
                        .font(.custom("Inter28pt-Regular", size: 14))
                        .foregroundColor(Color("ButtonColor"))
                        .font(.caption)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .accessibilityLabel("Erreur : veuillez choisir une photo de profil")
                        .accessibilityIdentifier("avatarErrorLabel")
                }
            }
            
            Button(action: {
                Task {
                    await signUpVM.createUser(email: signUpVM.email, password: signUpVM.password, name: signUpVM.name, avatarImage: signUpVM.selectedImage)//modif
                    
                    if signUpVM.errorMessage == "" && signUpVM.name != "" && signUpVM.selectedImage != nil {
                        flow = .signIn
                    }
                }
            }) {
                HStack {
                    if signUpVM.isLoading {
                        CustomSpinner(size: 20, lineWidth: 2)
                    } else {
                        Text("Sign Up")
                            .font(.custom("Inter24pt-SemiBold", size: 16))
                            .foregroundColor(.white)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color("ButtonColor"))
                .cornerRadius(4)
            }
            .padding(.horizontal)
            .padding(.top, 100)
            .accessibilityLabel("Créer un compte")
            .accessibilityIdentifier("createAccountButton")
        }
        .padding(.horizontal, 10)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .alert(isPresented: $signUpVM.showError) {
            Alert(
                title: Text("Error"),
                message: Text(signUpVM.errorMessage),
                dismissButton: .default(Text("OK")) {
                    signUpVM.showError = false
                }
            )
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Formulaire d'inscription")
        .onAppear {
#if DEBUG
            if isUITest {
                signUpVM.selectedImage = UIImage(systemName: "person.fill")
            }
#endif
        }
    }
}

#Preview {
    @Previewable @State var flow: RootView.AuthFlow = .signUp
    
    SignUpView(signUpVM: SignUpViewModel(), flow: $flow)
}

