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
    @State private var selectedImage: UIImage?
    @State private var cameraImage: UIImage?
    @State private var showImagePicker = false
    @State private var showCameraPicker = false
    
    var body: some View {
        VStack {
            Text("SignUp")
                .font(.custom("Inter24pt-SemiBold", size: 20))
                .foregroundColor(.white)
                .padding(.bottom, 40)
            
            VStack {
                VStack(spacing: 0) {
                    Text("E-mail adress")
                        .font(.custom("Inter28pt-Regular", size: 12))
                        .foregroundColor(.white)
                        .padding(.top, 10)
                        .padding(.leading, 15)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    CustomTextField(placeholder: "email@example.com", text: $signUpVM.email)
                        .padding(.bottom, 5)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                }
                .background(Color("TextfieldColor"))
                .cornerRadius(5)
                
                if signUpVM.email.isEmpty {
                    Text("Email is required")
                        .foregroundColor(Color("ButtonColor"))
                        .font(.caption)
                        .frame(maxWidth: .infinity, alignment: .leading)
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
                    
                    VStack {
                        ZStack(alignment: .leading) {
                            if signUpVM.password.isEmpty {
                                Text("Password")
                                    .font(.custom("Inter28pt-Regular", size: 16))
                                    .foregroundColor(.gray)
                                    .padding(.leading, 15)
                            }
                            
                            SecureField("", text: $signUpVM.password)
                                .padding(.leading, 15)
                                .frame(height: 20)
                                .font(.custom("Inter28pt-Regular", size: 16))
                                .foregroundColor(.white)
                                .cornerRadius(8)
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
                }
                if !signUpVM.isValidPassword() && !signUpVM.password.isEmpty {
                    Text("Password must contain 8 characters, 1 uppercase letter, 1 number, 1 special character")
                        .font(.custom("Inter28pt-Regular", size: 14))
                        .foregroundColor(Color("ButtonColor"))
                        .font(.caption)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            
            VStack(spacing: 0) {
                Text("Full name")
                    .font(.custom("Inter28pt-Regular", size: 12))
                    .foregroundColor(.white)
                    .padding(.top, 10)
                    .padding(.leading, 15)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                CustomTextField(placeholder: "Christopher Evans", text: $signUpVM.name)
                    .padding(.bottom, 5)
            }
            .background(Color("TextfieldColor"))
            .cornerRadius(5)
            
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
                        ImagePicker(selectedImage: $selectedImage)
                    }
                }
                .padding(.top, 30)
            }
            
            Button(action: {
                Task {
                    await signUpVM.createUser(email: signUpVM.email, password: signUpVM.password, name: signUpVM.name, avatarImage: selectedImage)
                    
                    if signUpVM.errorMessage == nil {
                        flow = .signIn
                    }
                }
            }) {
                HStack {
                    Text("Sign Up")
                        .font(.custom("Inter24pt-SemiBold", size: 16))
                        .foregroundColor(.white)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color("ButtonColor"))
                .cornerRadius(4)
            }
            .padding(.horizontal)
            .padding(.top, 100)
        }
        .padding(.horizontal, 10)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
    }
}
#Preview {
    @Previewable @State var flow: RootView.AuthFlow = .signUp
    
    SignUpView(signUpVM: SignUpViewModel(), flow: $flow)
}

