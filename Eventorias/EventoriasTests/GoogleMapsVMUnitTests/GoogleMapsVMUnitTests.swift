//
//  GoogleMapsVMUnitTests.swift
//  EventoriasTests
//
//  Created by Ordinateur elena on 18/10/2025.
//

import XCTest
@testable import Eventorias
import SwiftUI

final class GoogleMapsVMUnitTests: XCTestCase {
    var viewModel: GoogleMapsViewModel!
    var mockService: MockGoogleMapsService!
    
    override func setUp() {
        super.setUp()
        mockService = MockGoogleMapsService()
        viewModel = GoogleMapsViewModel(googleMapsService: mockService)
    }
    
    override func tearDown() {
        viewModel = nil
        mockService = nil
        super.tearDown()
    }
    
    func testLoadMapSuccess() throws {
        //Given
        mockService.urlToReturn = URL(string: "https://maps.google.com")
        
        //When
        viewModel.loadMap(for: "Paris")
        
        //Then
        XCTAssertEqual(viewModel.mapURL, URL(string: "https://maps.google.com"))
        XCTAssertFalse(viewModel.showError)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func testLoadMapKeyNotFoundError() throws {
        //Given
        mockService.errorToThrow = AppError.GoogleMapsError.keyNotFound
        
        //When
        viewModel.loadMap(for: "Paris")
        
        //Then
        XCTAssertNil(viewModel.mapURL)
        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, AppError.GoogleMapsError.keyNotFound.errorDescription)
    }
    
    func testLoadMapInvalidURLError() throws {
        //Given
        mockService.errorToThrow = AppError.GoogleMapsError.invalidURL
        
        //When
        viewModel.loadMap(for: "Paris")
        
        //Then
        XCTAssertNil(viewModel.mapURL)
        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, AppError.GoogleMapsError.invalidURL.errorDescription)
    }
}
