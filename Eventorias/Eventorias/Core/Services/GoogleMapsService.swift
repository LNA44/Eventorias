//
//  GoogleMapsService.swift
//  Eventorias
//
//  Created by Ordinateur elena on 08/10/2025.
//

import Foundation

struct GoogleMapsService: GoogleMapsServicing {
    static let shared = GoogleMapsService()
    private var apiKey: String {
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

    func createMapURL(for address: String) throws -> URL? {
        let encodedAddress = address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let encodedPipe = "%7C" 
        let key = try self.apiKey
        let urlString = "https://maps.googleapis.com/maps/api/staticmap?center=\(encodedAddress)&zoom=15&size=180x90&markers=color:red\(encodedPipe)\(encodedAddress)&key=\(key)"
        guard let url = URL(string: urlString) else {
            throw AppError.GoogleMapsError.invalidURL
        }
        return url
    }
}
