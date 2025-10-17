//
//  AppError.swift
//  Eventorias
//
//  Created by Ordinateur elena on 15/10/2025.
//

import Foundation

enum AppError: Error {
    enum GoogleMapsError: Error {
        case keyNotFound
        case invalidURL
        
        var errorDescription: String {
            switch self {
            case .keyNotFound: return "Google API key not found"
            case .invalidURL: return "Invalid URL"
            }
        }
    }
    
    enum FirestoreError: Error {
        case saveUserFailed(underlying: Error)
        case imageError(String)
    }
    
    enum AuthError: Error {
        case userNotCreated
        case unknown
        
        var errorDescription: String {
            switch self {
            case .userNotCreated: return "You didn't create an account yet"
            case .unknown: return "An unknown error occurred"
                
            }
        }
    }
    
    enum StorageError: Error {
        case imageConversionFailed
    }
}
