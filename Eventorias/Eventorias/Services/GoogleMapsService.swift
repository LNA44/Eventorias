//
//  GoogleMapsService.swift
//  Eventorias
//
//  Created by Ordinateur elena on 08/10/2025.
//

import Foundation

struct GoogleMapsService: GoogleMapsServicing {
    static let shared = GoogleMapsService()
    static var apiKey: String {
        get throws { 
                guard let path = Bundle.main.path(forResource: "Key", ofType: "plist"),
                      let dict = NSDictionary(contentsOfFile: path),
                      let key = dict["GoogleApiKey"] as? String else {
                    throw AppError.GoogleMapsError.keyNotFound
                }
                return key
            }
        }
    
    private init() {}

    static func staticMapURL(for address: String, zoom: Int = 15, size: String = "180x90") throws -> URL? {
        let encodedAddress = address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let encodedPipe = "%7C"
        print("Adresse encodée:", encodedAddress)
        let key = try apiKey //a supprimer aprs vérif
        print("Clé API trouvée:", key)
        let urlString = "https://maps.googleapis.com/maps/api/staticmap?center=\(encodedAddress)&zoom=\(zoom)&size=\(size)&markers=color:red\(encodedPipe)\(encodedAddress)&key=\(try apiKey)"
        guard let url = URL(string: urlString) else {
            throw AppError.GoogleMapsError.invalidURL
        }
        print("url dans service: \(url)")
        return url
    }
}
