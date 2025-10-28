//
//  FirebaseStorageService.swift
//  Eventorias
//
//  Created by Ordinateur elena on 13/10/2025.
//

import Firebase
import FirebaseStorage
import UIKit

class FirebaseStorageService: FirebaseStorageServicing {
    static let shared = FirebaseStorageService()
    
    private init() {}
   
    func uploadAvatarImage(userId: String, image: UIImage) async throws -> String {
        // Conversion de l'image en Data
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw AppError.StorageError.imageConversionFailed
        }
        
        let storageRef = Storage.storage().reference().child("avatars/\(userId).jpg")
        
        // Upload de l'image
        _ = try await storageRef.putDataAsync(imageData, metadata: nil)
        
        // Récupération de l'URL publique
        let url = try await storageRef.downloadURL()
        return url.absoluteString
    }
    
    func uploadImage(_ image: UIImage) async throws -> String {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw AppError.FirestoreError.imageError("Impossible to convert image to JPEG")
        }
        let storageRef = Storage.storage().reference().child("eventImages/\(UUID().uuidString).jpg") //cree un sous dossier eventImages
        _ = try await storageRef.putDataAsync(imageData) //envoie les donnees vers firebaseStorage
        return try await storageRef.downloadURL().absoluteString //url publique de l'image stockee, sous forme de string
    }
}
