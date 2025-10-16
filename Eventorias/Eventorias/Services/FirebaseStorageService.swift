//
//  FirebaseStorageService.swift
//  Eventorias
//
//  Created by Ordinateur elena on 13/10/2025.
//

import Firebase
import FirebaseStorage
import UIKit

class FirebaseStorageService {
    static let shared = FirebaseStorageService()
    
    private init() {}
    
    /*func uploadAvatarImage(userId: String, image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(NSError(domain: "ImageError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Impossible to convert image"])))
            return
        }
        //Upload sur firebase Storage
        let storageRef = Storage.storage().reference().child("avatars/\(userId).jpg")
        
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                completion(.failure(AppError.StorageError.imageConversionFailed))
                return
            }
            //Récupère l'URL publique
            storageRef.downloadURL { url, error in
                if let error = error {
                    completion(.failure(AppError.StorageError.downloadURLFailed))
                    return
                }
                
                guard let url = url else {
                    completion(.failure(NSError(domain: "URLError", code: -1, userInfo: nil)))
                    return
                }
                completion(.success(url.absoluteString))
            }
        }
     }*/
    
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
    //Wrapper async de la fonction d'en haut
    /*func uploadAvatarImageAsync(userId: String, image: UIImage) async throws -> String {
        try await withCheckedThrowingContinuation { continuation in
            self.uploadAvatarImage(userId: userId, image: image) { result in
                switch result {
                case .success(let url):
                    continuation.resume(returning: url)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }*/
}
