//
//  CreateEventView.swift
//  Eventorias
//
//  Created by Ordinateur elena on 07/10/2025.
//

import SwiftUI
import Combine

struct CreateEventView: View {
    @Bindable var eventsVM: EventsViewModel
    @State private var name = ""
    @State private var description = ""
    @State private var date = Date()
    @State private var dateString: String = ""
    @State private var time = Date()
    @State private var timeString: String = ""
    @State private var location = ""
    @State private var guests: String = ""
    @State private var selectedImage: UIImage?
    @State private var showCameraPicker = false
    @State private var cameraImage: UIImage?
    @State private var showImagePicker = false
    @State private var isSaving = false
    @State private var selectedCategory: String = "Other"
    let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "MM/dd/yyyy"
        return f
    }()
    
    let timeFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        f.locale = Locale(identifier: "en_US_POSIX")
        return f
    }()
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack(spacing: 8) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 18, height: 18)
                            .foregroundColor(.white)
                    }
                    Text("Creation of an event")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    Spacer()
                }
                .padding()
                .background(Color.black)
                
                VStack(spacing: 20) {
                    VStack(spacing: 0) {
                        Text("Title")
                            .foregroundColor(.white)
                            .padding(.top, 10)
                            .padding(.leading, 15)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        CustomTextField(placeholder: "New event", text: $name)
                            .padding(.bottom, 5)
                    }
                    .background(Color("TextfieldColor"))
                    .cornerRadius(5)

                    VStack(spacing: 0) {
                        Text("Description")
                            .foregroundColor(.white)
                            .padding(.top, 10)
                            .padding(.leading, 15)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        CustomTextField(placeholder: "Tap here to enter your description", text: $description)
                            .padding(.bottom, 5)
                    }
                    .background(Color("TextfieldColor"))
                    .cornerRadius(5)
                    
                    HStack(spacing: 15) {
                        VStack(spacing: 0) {
                            Text("Date")
                                .foregroundColor(.white)
                                .padding(.top, 10)
                                .padding(.leading, 15)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            CustomTextField(placeholder: "MM/DD/YYYY", text: $dateString)
                                .onChange(of: dateString) {_, newValue in
                                    // tenter de convertir le texte en Date
                                    if let newDate = dateFormatter.date(from: newValue) {
                                        date = newDate
                                    } else {
                                        // optionnel : reset ou message d'erreur si la saisie est invalide
                                        print("Date invalide")
                                    }
                                }
                                .padding(.bottom, 5)
                        }
                        .background(Color("TextfieldColor"))
                        .cornerRadius(5)
                        
                        VStack(spacing: 0) {
                            Text("Time")
                                .foregroundColor(.white)
                                .padding(.top, 10)
                                .padding(.leading, 15)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            CustomTextField(placeholder: "HH : MM", text: $timeString)
                                .onChange(of: timeString) {_, newValue in
                                    if let newTime = timeFormatter.date(from: newValue) {
                                        time = newTime
                                    } else {
                                        print("Heure invalide")
                                    }
                                }
                                .padding(.bottom, 5)
                            
                        }
                        .background(Color("TextfieldColor"))
                        .cornerRadius(5)

                    }
                    
                    VStack(spacing: 0) {
                        Text("Address")
                            .foregroundColor(.white)
                            .padding(.top, 10)
                            .padding(.leading, 15)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        CustomTextField(placeholder: "Enter full address", text: $location)
                            .padding(.bottom, 5)
                    }
                    .background(Color("TextfieldColor"))
                    .cornerRadius(5)
                    
                    VStack(spacing: 0) {
                        Text("Guests")
                            .foregroundColor(.white)
                            .padding(.top, 10)
                            .padding(.leading, 15)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        CustomTextField(placeholder: "Enter email addresses, separated by commas", text: $guests)
                            .padding(.bottom, 5)
                    }
                    .background(Color("TextfieldColor"))
                    .cornerRadius(5)
                    
                    VStack(spacing: 0) {
                        Text("Category")
                            .foregroundColor(.white)
                            .padding(.top, 10)
                            .padding(.leading, 15)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Menu {
                            ForEach(Categories.all, id: \.self) { category in
                                Button(action: {
                                    selectedCategory = category
                                }) {
                                    Text(category)
                                }
                            }
                        } label: {
                            HStack {
                                    Text(selectedCategory.isEmpty ? "Select a category" : selectedCategory)
                                        .foregroundColor(.white)
                                    Image(systemName: "chevron.down") // flèche vers le bas
                                        .foregroundColor(.white)
                                        .font(.system(size: 14, weight: .bold))
                                Spacer()
                                }
                                .padding(.leading, 15)
                                .padding(.vertical, 8)
                        }
                    }
                    .background(Color("TextfieldColor"))
                    .cornerRadius(5)
                    
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
                    
                    Spacer()
                    
                    Button(action: {
                        isSaving = true
                        Task {
                            var imageURL: String? = nil
                            if let selectedImage {
                                imageURL = try? await FirestoreService.shared.uploadImage(selectedImage)
                            }
                            await eventsVM.addEvent(
                                name: name,
                                description: description,
                                date: date,
                                time: time,
                                location: location,
                                category: selectedCategory,
                                guests: guests,
                                imageURL: imageURL
                            )
                            isSaving = false
                            dismiss()
                        }
                    }) {
                        Text("Validate")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, minHeight: 44)
                            .background(Color("ButtonColor"))
                            .cornerRadius(5)
                            .padding(.horizontal)
                    }
                    .disabled(name.isEmpty || location.isEmpty)
                    .padding(.bottom, 24)
                }
                .padding(.top, 10)
                .padding(.horizontal, 10)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    CreateEventView(eventsVM: EventsViewModel())
}
