//
//  GoogleMapsVM.swift
//  Eventorias
//
//  Created by Ordinateur elena on 15/10/2025.
//

import SwiftUI
import Foundation

@Observable class GoogleMapsViewModel {
    private var googleMapsService: GoogleMapsServicing
    var mapURL: URL?
    var errorMessage: String?
    var showError: Bool = false
        
    init(
        googleMapsService: GoogleMapsServicing = GoogleMapsService.shared,
    ) {
        self.googleMapsService = googleMapsService
    }
    
    func loadMap(for location: String) {
        do {
            mapURL = try googleMapsService.createMapURL(for: location)
        } catch let error as AppError.GoogleMapsError {
            switch error {
            case .keyNotFound:
                showError = true
                errorMessage = error.errorDescription
            case .invalidURL:
                showError = true
                errorMessage = error.errorDescription
            }
        } catch {
            showError = true
            errorMessage = "Unknown error \(error.localizedDescription)"
        }
    }
}
    
