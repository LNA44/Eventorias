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
    @State private var showAlert = false
    @State private var alertMessage = ""
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
            ScrollView {
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
                            .font(.custom("Inter24pt-SemiBold", size: 20))
                            .foregroundColor(.white)
                            .lineLimit(1)
                            .truncationMode(.tail)
                        Spacer()
                    }
                    .padding()
                    .background(Color.black)
                    
                    VStack(spacing: 0) {
                        VStack(spacing: 0) {
                            Text("Title")
                                .font(.custom("Inter28pt-Regular", size: 12))
                                .foregroundColor(.white)
                                .padding(.top, 10)
                                .padding(.leading, 15)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            CustomTextField(placeholder: "New event", text: $name)
                                .padding(.bottom, 5)
                        }
                        .background(Color("TextfieldColor"))
                        .cornerRadius(5)
                        .padding(.bottom, name.isEmpty ? 0 : 20)
                        
                        if name.isEmpty {
                            Text("The name of the event is required")
                                .font(.custom("Inter28pt-Regular", size: 14))
                                .foregroundColor(Color("ButtonColor"))
                                .font(.caption)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.bottom, 20)
                        }
                        
                        VStack(spacing: 0) {
                            Text("Description")
                                .font(.custom("Inter28pt-Regular", size: 12))
                                .foregroundColor(.white)
                                .padding(.top, 10)
                                .padding(.leading, 15)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            CustomTextField(placeholder: "Tap here to enter your description", text: $description)
                                .padding(.bottom, 5)
                        }
                        .background(Color("TextfieldColor"))
                        .cornerRadius(5)
                        .padding(.bottom, description.isEmpty ? 0 : 20)
                        
                        if description.isEmpty {
                            Text("The description of the event is required")
                                .font(.custom("Inter28pt-Regular", size: 14))
                                .foregroundColor(Color("ButtonColor"))
                                .font(.caption)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.bottom, 20)
                        }
                        
                        HStack(alignment: .top, spacing: 15) {
                            // Date field + message
                            VStack(spacing: 0) {
                                VStack(spacing: 0) {
                                    Text("Date")
                                        .font(.custom("Inter28pt-Regular", size: 12))
                                        .foregroundColor(.white)
                                        .padding(.top, 10)
                                        .padding(.leading, 15)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    CustomTextField(placeholder: "MM/DD/YYYY", text: $dateString)
                                        .onChange(of: dateString) { _, newValue in
                                            if let newDate = dateFormatter.date(from: newValue) {
                                                date = newDate
                                            } else {
                                                print("Date invalide")
                                            }
                                        }
                                        .padding(.bottom, 5)
                                }
                                .background(Color("TextfieldColor"))
                                .cornerRadius(5)
                                .padding(.bottom, 0) // padding interne

                                if dateString.isEmpty {
                                    Text("The date of the event is required")
                                        .font(.caption)
                                        .foregroundColor(Color("ButtonColor"))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.top, 5)
                                        .padding(.bottom, 20) // espace sous le message
                                } else {
                                    Spacer().frame(height: 20) // espace sous le champ même sans message
                                }
                            }

                            // Time field + message
                            VStack(spacing: 0) {
                                VStack(spacing: 0) {
                                    Text("Time")
                                        .font(.custom("Inter28pt-Regular", size: 12))
                                        .foregroundColor(.white)
                                        .padding(.top, 10)
                                        .padding(.leading, 15)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    CustomTextField(placeholder: "HH : MM", text: $timeString)
                                        .onChange(of: timeString) { _, newValue in
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
                                .padding(.bottom, 0)

                                if timeString.isEmpty {
                                    Text("The time of the event is required")
                                        .font(.caption)
                                        .foregroundColor(Color("ButtonColor"))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.top, 5)
                                        .padding(.bottom, 20)
                                } else {
                                    Spacer().frame(height: 20)
                                }
                            }
                        }
                        
                        VStack(spacing: 0) {
                            Text("Address")
                                .font(.custom("Inter28pt-Regular", size: 12))
                                .foregroundColor(.white)
                                .padding(.top, 10)
                                .padding(.leading, 15)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            CustomTextField(placeholder: "Enter full address", text: $location)
                                .padding(.bottom, 5)
                        }
                        .background(Color("TextfieldColor"))
                        .cornerRadius(5)
                        .padding(.bottom, location.isEmpty ? 0 : 20)
                        
                        if location.isEmpty {
                            Text("The adress of the event is required")
                                .font(.custom("Inter28pt-Regular", size: 14))
                                .foregroundColor(Color("ButtonColor"))
                                .font(.caption)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.bottom, 20)
                        }
                        
                        VStack(spacing: 0) {
                            Text("Guests")
                                .font(.custom("Inter28pt-Regular", size: 12))
                                .foregroundColor(.white)
                                .padding(.top, 10)
                                .padding(.leading, 15)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            CustomTextField(placeholder: "Enter email addresses, separated by commas", text: $guests)
                                .padding(.bottom, 5)
                                .autocapitalization(.none)
                                .keyboardType(.emailAddress)
                        }
                        .background(Color("TextfieldColor"))
                        .cornerRadius(5)
                        .padding(.bottom, guests.isEmpty ? 0 : 20)
                        
                        if guests.isEmpty {
                            Text("The guests list is required")
                                .font(.custom("Inter28pt-Regular", size: 14))
                                .foregroundColor(Color("ButtonColor"))
                                .font(.caption)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.bottom, 20)
                        }
                        
                        VStack(spacing: 0) {
                            Text("Category")
                                .font(.custom("Inter28pt-Regular", size: 12))
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
                                            .font(.custom("Inter28pt-Regular", size: 16))
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(selectedCategory.isEmpty ? "Select a category" : selectedCategory)
                                        .foregroundColor(.white)
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.white)
                                        .font(.system(size: 14, weight: .bold))
                                    Spacer()
                                }
                                .padding(.leading, 15)
                                .padding(.top, 5)
                                .padding(.bottom, 8)
                            }
                        }
                        .background(Color("TextfieldColor"))
                        .cornerRadius(5)
                        .padding(.bottom, selectedCategory.isEmpty ? 0 : 20)
                        
                        if selectedCategory.isEmpty {
                            Text("Choose the category of the event")
                                .font(.custom("Inter28pt-Regular", size: 14))
                                .foregroundColor(Color("ButtonColor"))
                                .font(.caption)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.bottom, 20)
                        }
                        
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
                        .padding(.bottom, selectedImage == nil ? 0 : 20)
                        
                        if selectedImage == nil {
                            Text("Choose or take a photo")
                                .font(.custom("Inter28pt-Regular", size: 14))
                                .foregroundColor(Color("ButtonColor"))
                                .font(.caption)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.bottom, 20)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            isSaving = true
                            guard let selectedImage else {
                                return
                            }
                            
                            Task {
                                let imageURL = await eventsVM.uploadEventImage(selectedImage)
                                
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
                                
                                if !eventsVM.notFoundEmails.isEmpty {
                                    alertMessage = "Coudn't find those emails : \(eventsVM.notFoundEmails.joined(separator: ", "))"
                                    showAlert = true
                                } else if eventsVM.showError {
                                    alertMessage = eventsVM.errorMessage
                                    showAlert = true
                                    eventsVM.showError = false
                                } else {
                                    // tout est ok → fermer la vue
                                    dismiss()
                                }
                            }
                        }) {
                            HStack {
                                if isSaving {
                                    CustomSpinner(size: 20, lineWidth: 2)
                                } else {
                                    Text("Validate")
                                        .font(.custom("Inter24pt-SemiBold", size: 16))
                                        .foregroundColor(.white)
                                }
                            }
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
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .navigationBarBackButtonHidden(true)
        .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Attention"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK")) {}
                )
            }
    }
}

#Preview {
    CreateEventView(eventsVM: EventsViewModel())
}
