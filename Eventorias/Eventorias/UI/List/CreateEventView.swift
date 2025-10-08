//
//  CreateEventView.swift
//  Eventorias
//
//  Created by Ordinateur elena on 07/10/2025.
//

import SwiftUI

struct CreateEventView: View {
    @Bindable var eventsVM: EventsViewModel
    @State private var name = ""
    @State private var description = ""
    @State private var date = Date()
    @State private var time = Date()
    @State private var location = ""
    @State private var category = ""
    @State private var guests: [String] = []
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false
    @State private var showDatePickerSheet = false
    @State private var showTimePickerSheet = false
    @State private var isSaving = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Détails")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            ZStack(alignment: .leading) {
                                if name.isEmpty {
                                    Text("Nom")
                                        .foregroundColor(.gray)
                                        .padding(.leading, 8)
                                }
                                TextField("", text: $name)
                                    .foregroundColor(.white)
                                    .padding(8)
                            }
                            .background(Color("TextfieldColor"))
                            .cornerRadius(8)
                            
                            ZStack(alignment: .leading) {
                                if description.isEmpty {
                                    Text("Description")
                                        .foregroundColor(.gray) // placeholder gris
                                        .padding(.leading, 8)
                                }
                                TextField("", text: $description)
                                    .foregroundColor(.white) // texte saisi en blanc
                                    .padding(8)
                            }
                            .background(Color("TextfieldColor"))
                            .cornerRadius(8)
                            
                            ZStack(alignment: .leading) {
                                if location.isEmpty {
                                    Text("Lieu")
                                        .foregroundColor(.gray) // placeholder gris
                                        .padding(.leading, 8)
                                }
                                TextField("", text: $location)
                                    .foregroundColor(.white) // texte saisi en blanc
                                    .padding(8)
                            }
                            .background(Color("TextfieldColor"))
                            .cornerRadius(8)
                            
                            ZStack(alignment: .leading) {
                                if category.isEmpty {
                                    Text("Catégorie")
                                        .foregroundColor(.gray) // placeholder gris
                                        .padding(.leading, 8)
                                }
                                TextField("", text: $category)
                                    .foregroundColor(.white) // texte saisi en blanc
                                    .padding(8)
                            }
                            .background(Color("TextfieldColor"))
                            .cornerRadius(8)
                            
                        }
                        .padding()
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Date")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            Button {
                                showDatePickerSheet.toggle()
                            } label: {
                                HStack {
                                    Text(date, style: .date)
                                        .foregroundColor(.white)
                                    Spacer()
                                }
                                .padding(8)
                                .background(Color("TextfieldColor"))
                                .cornerRadius(8)
                            }
                            .sheet(isPresented: $showDatePickerSheet) {
                                ZStack {
                                    Color.black.ignoresSafeArea() // fond de la sheet
                                    VStack(spacing: 20) {
                                        WhitePicker(date: $date, mode: .date)
                                            .frame(height: 200)
                                            .cornerRadius(8)
                                            .padding(.horizontal)
                                        
                                        Button("Valider") {
                                            showDatePickerSheet = false
                                        }
                                        .padding()
                                        .background(Color("ButtonColor"))
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                    }
                                    .padding()
                                }
                            }
                            
                            Button {
                                showTimePickerSheet.toggle()
                            } label: {
                                HStack {
                                    Text(time, style: .time)
                                        .foregroundColor(.white)
                                    Spacer()
                                }
                                .padding(8)
                                .background(Color("TextfieldColor"))
                                .cornerRadius(8)
                            }
                            .sheet(isPresented: $showTimePickerSheet) {
                                ZStack {
                                    Color.black.ignoresSafeArea()
                                    VStack(spacing: 20) {
                                        WhitePicker(date: $time, mode: .time)
                                            .frame(height: 200)
                                            .cornerRadius(8)
                                            .padding(.horizontal)
                                        
                                        Button("Valider") {
                                            showTimePickerSheet = false
                                        }
                                        .padding()
                                        .background(Color("ButtonColor"))
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                    }
                                    .padding()
                                }
                            }
                        }
                        .padding()
                        
                        // MARK: Invités
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Invités")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            
                            ZStack(alignment: .leading) {
                                if guests.joined(separator: ",").isEmpty {
                                    Text("Emails des invités séparés par ,")
                                        .foregroundColor(.gray) // placeholder gris
                                        .padding(.leading, 8)
                                }
                                TextField(
                                    "",
                                    text: Binding(
                                        get: { guests.joined(separator: ",") },
                                        set: { guests = $0.components(separatedBy: ",") }
                                    )
                                )
                                .foregroundColor(.white) // texte saisi en blanc
                                .padding(8)
                            }
                            .background(Color("TextfieldColor"))
                            .cornerRadius(8)
                        }
                        .padding()
                        
                        // MARK: Image
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Image")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            if let selectedImage {
                                Image(uiImage: selectedImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 150)
                                    .clipped()
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.white.opacity(0.5), lineWidth: 1)
                                    )
                            }
                            
                            Button(action: { showImagePicker = true }) {
                                HStack {
                                    Image(systemName: "photo")
                                    Text(selectedImage == nil ? "Choisir une image" : "Modifier l'image")
                                }
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color("TextfieldColor"))
                                .cornerRadius(8)
                            }
                            .sheet(isPresented: $showImagePicker) {
                                ImagePicker(selectedImage: $selectedImage)
                            }
                        }
                        .padding()
                        
                        // MARK: Bouton Créer
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
                                    category: category,
                                    guests: guests,
                                    userProfileImage: "Avatar",
                                    imageURL: imageURL
                                )
                                isSaving = false
                                dismiss()
                            }
                        }) {
                            Text("Créer l'événement")
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, minHeight: 44)
                                .background(Color("ButtonColor"))
                                .cornerRadius(8)
                                .padding(.horizontal)
                        }
                        .disabled(name.isEmpty || location.isEmpty)
                        .padding(.bottom, 24)
                    }
                }
                .background(Color.black.ignoresSafeArea())
                .navigationTitle("Nouvel événement")
                
                if isSaving {
                        Color.black.opacity(0.5).ignoresSafeArea()
                        ProgressView("Création en cours...")
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(1.5)
                    }
            }
        }
    }
}

#Preview {
    CreateEventView(eventsVM: EventsViewModel())
}
