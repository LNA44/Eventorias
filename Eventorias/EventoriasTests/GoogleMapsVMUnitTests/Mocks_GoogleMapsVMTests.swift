//
//  Mocks_GoogleMapsVMTests.swift
//  EventoriasTests
//
//  Created by Ordinateur elena on 18/10/2025.
//

import Foundation
@testable import Eventorias

class MockGoogleMapsService: GoogleMapsServicing {
    var urlToReturn: URL?
    var errorToThrow: Error?

    func createMapURL(for address: String) throws -> URL? {
        if let error = errorToThrow { throw error }
        return urlToReturn ?? URL(string: "https://mock.url")!
    }
}
