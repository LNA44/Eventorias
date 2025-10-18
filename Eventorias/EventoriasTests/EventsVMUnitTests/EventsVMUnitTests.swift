//
//  EventVMUnitTests.swift
//  EventoriasTests
//
//  Created by Ordinateur elena on 18/10/2025.
//

import XCTest
@testable import Eventorias

@MainActor
final class EventsViewModelTests: XCTestCase {
    
    var viewModel: EventsViewModel!
    var mockFirestoreService: MockFirestoreServiceForEventsVM!
    var mockAuthService: MockAuthServiceForEventsVM!
    
    override func setUp() {
        super.setUp()
        mockFirestoreService = MockFirestoreServiceForEventsVM()
        mockAuthService = MockAuthServiceForEventsVM()
        viewModel = EventsViewModel(firestoreService: mockFirestoreService, authService: mockAuthService)
    }
    
    override func tearDown() {
        viewModel = nil
        mockFirestoreService = nil
        mockAuthService = nil
        super.tearDown()
    }
    
    func testFetchEvents_Success() async {
        // Given
        mockFirestoreService.eventsToReturn = [
            Event(id: "1", name: "Concert", description: "Rock night", date: Date(), location: "Paris", category: "Music", guests: [], userID: "user1", imageURL: nil, isUserInvited: false)
        ]
        
        // When
        await viewModel.fetchEvents()
        
        // Then
        XCTAssertTrue(mockFirestoreService.didFetchEvents)
        XCTAssertEqual(viewModel.events.count, 1)
        XCTAssertFalse(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, "")
    }
    
    func testFetchEvents_Failure() async {
        // Given
        mockFirestoreService.shouldThrowFetchError = true
        
        // When
        await viewModel.fetchEvents()
        
        // Then
        XCTAssertTrue(viewModel.errorMessage.contains("An error has occurred"))
    }
    
    // MARK: - addEvent()
    
    func testAddEvent_Success() async {
        // Given
        let name = "Apéro Dev"
        let description = "Networking"
        let date = Date()
        let time = Date()
        let location = "Lyon"
        let category = "Meetup"
        let guests = "john@example.com"
        mockFirestoreService.convertEmailsResult = ConvertEmailsResult(uids: ["guest123"], notFound: [])
        
        // When
        await viewModel.addEvent(
            name: name,
            description: description,
            date: date,
            time: time,
            location: location,
            category: category,
            guests: guests,
            imageURL: nil
        )
        
        // Then
        XCTAssertEqual(mockFirestoreService.didAddEvent?.name, name)
        XCTAssertEqual(viewModel.events.count, 1)
        XCTAssertFalse(viewModel.showError)
        XCTAssertTrue(viewModel.notFoundEmails.isEmpty)
    }
    
    func testAddEvent_Failure_WhenAddThrows() async {
        // Given
        mockFirestoreService.shouldThrowAddError = true
        let date = Date()
        let time = Date()
        
        // When
        await viewModel.addEvent(
            name: "Fail Event",
            description: "Should not be added",
            date: date,
            time: time,
            location: "Paris",
            category: "Error",
            guests: "",
            imageURL: nil
        )
        
        // Then
        XCTAssertTrue(viewModel.showError)
        XCTAssertFalse(viewModel.errorMessage.isEmpty)
    }
    
    func testAddEvent_Failure_WhenCurrentUserIDIsNil() async {
        // Given
        mockAuthService.currentUserID = nil
        let date = Date()
        let time = Date()
        
        // When
        await viewModel.addEvent(
            name: "No User Event",
            description: "No user ID available",
            date: date,
            time: time,
            location: "Toulouse",
            category: "Tech",
            guests: "",
            imageURL: nil
        )
        
        // Then
        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, "Impossible to get current user")
    }
    
    // MARK: - sortByDate()
    
    func testSortByDateAscending() {
        // Given
        let now = Date()
        let later = now.addingTimeInterval(3600)
        viewModel.events = [
            Event(id: "1", name: "Later", description: "", date: later, location: "", category: "", guests: [], userID: "", imageURL: nil, isUserInvited: false),
            Event(id: "2", name: "Now", description: "", date: now, location: "", category: "", guests: [], userID: "", imageURL: nil, isUserInvited: false)
        ]
        
        // When
        viewModel.sortByDate(ascending: true)
        
        // Then
        XCTAssertEqual(viewModel.events.first?.name, "Now")
    }
    
    func testSortByDateDescending() {
        // Given
        let now = Date()
        let later = now.addingTimeInterval(3600)
        viewModel.events = [
            Event(id: "1", name: "Later", description: "", date: later, location: "", category: "", guests: [], userID: "", imageURL: nil, isUserInvited: false),
            Event(id: "2", name: "Now", description: "", date: now, location: "", category: "", guests: [], userID: "", imageURL: nil, isUserInvited: false)
        ]
        
        // When
        viewModel.sortByDate(ascending: false)
        
        // Then
        XCTAssertEqual(viewModel.events.first?.name, "Later")
    }
    
    // MARK: - uploadEventImage()
    
    func testUploadEventImage_Success() async {
        // Given
        let image = UIImage()
        mockFirestoreService.imageUploadURL = "https://mock.com/uploaded.png"
        
        // When
        let result = await viewModel.uploadEventImage(image)
        
        // Then
        XCTAssertEqual(result, "https://mock.com/uploaded.png")
        XCTAssertFalse(viewModel.showError)
    }
    
    func testUploadEventImage_Failure() async {
        // Given
        mockFirestoreService.shouldThrowUploadError = true
        let image = UIImage()
        
        // When
        let result = await viewModel.uploadEventImage(image)
        
        // Then
        XCTAssertNil(result)
        XCTAssertTrue(viewModel.showError)
        XCTAssertFalse(viewModel.errorMessage.isEmpty)
    }
    
    // MARK: - loadAvatars()
    
    func testLoadAvatars_Success() async {
        // Given
        let event = Event(id: "1", name: "Event", description: "", date: Date(), location: "", category: "", guests: [], userID: "user123", imageURL: nil, isUserInvited: false)
        viewModel.events = [event]
        mockFirestoreService.avatarURLToReturn = "https://mock.com/avatar.png"
        
        // When
        await viewModel.loadAvatars()
        
        // Then
        XCTAssertEqual(viewModel.getAvatar(for: "user123"), "https://mock.com/avatar.png")
    }
    
    func testLoadAvatars_Failure() async {
        // Given
        let event = Event(id: "1", name: "Event", description: "", date: Date(), location: "", category: "", guests: [], userID: "user123", imageURL: nil, isUserInvited: false)
        viewModel.events = [event]
        mockFirestoreService.shouldThrowAvatarError = true
        
        // When
        await viewModel.loadAvatars()
        
        // Then
        XCTAssertTrue(viewModel.showError)
        XCTAssertFalse(viewModel.errorMessage.isEmpty)
    }
}
