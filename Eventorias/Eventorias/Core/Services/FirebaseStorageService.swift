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
    private let storage: Storage
    
    private init() {
        storage = Storage.storage()
    }
   
    func uploadAvatarImage(userId: String, image: UIImage) async throws -> String {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw AppError.StorageError.imageConversionFailed
        }
        
        let storageRef = storage.reference().child("avatars/\(userId).jpg")
        
        _ = try await storageRef.putDataAsync(imageData, metadata: nil)
        
        let url = try await storageRef.downloadURL()
        return url.absoluteString
    }
    
    func uploadImage(_ image: UIImage) async throws -> String {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw AppError.FirestoreError.imageError("Impossible to convert image to JPEG")
        }
        let storageRef = storage.reference().child("eventImages/\(UUID().uuidString).jpg")
        _ = try await storageRef.putDataAsync(imageData)
        return try await storageRef.downloadURL().absoluteString
    }
}
