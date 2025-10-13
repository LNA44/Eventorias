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
    
    func uploadAvatarImage(userId: String, image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(NSError(domain: "ImageError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Impossible to convert image"])))
            return
        }
        
        let storageRef = Storage.storage().reference().child("avatars/\(userId).jpg")
        
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            storageRef.downloadURL { url, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let url = url else {
                    completion(.failure(NSError(domain: "URLError", code: -1, userInfo: nil)))
                    return
                }
                
                // Stocker l'URL dans Firestore
                let db = Firestore.firestore()
                db.collection("users").document(userId).setData([
                    "avatarURL": url.absoluteString
                ], merge: true) { err in
                    if let err = err {
                        completion(.failure(err))
                    } else {
                        completion(.success(url.absoluteString))
                    }
                }
            }
        }
    }
}
