//
//  GoogleMapsService.swift
//  Eventorias
//
//  Created by Ordinateur elena on 08/10/2025.
//

import Foundation

struct GoogleMapsService {
    static let shared = GoogleMapsService()
    
    private init() {}

    static var apiKey: String {
            guard let path = Bundle.main.path(forResource: "Key", ofType: "plist"),
                  let dict = NSDictionary(contentsOfFile: path),
                  let key = dict["GoogleApiKey"] as? String else {
                fatalError("Clé Google Maps introuvable")
            }
            return key
        }

    static func staticMapURL(for address: String, zoom: Int = 15, size: String = "180x90") -> URL? {
        let decodedAddress = address.removingPercentEncoding ?? address
        let encodedAddress = decodedAddress.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = """
            https://maps.googleapis.com/maps/api/staticmap?center=\(encodedAddress)&zoom=\(zoom)&size=\(size)&markers=color:red|\(encodedAddress)&key=\(apiKey)
            """
        return URL(string: urlString)
    }
}
