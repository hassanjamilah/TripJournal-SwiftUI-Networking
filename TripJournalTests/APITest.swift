//
//  APITest.swift
//  TripJournalTests
//
//  Created by Hassan Jamila on 17/1/25.
//

import XCTest
@testable import TripJournal


final class APITest: XCTestCase {
    
    func testRegisterAPIURL() {
        let value: JournalServiceLive.APIEndPoints = JournalServiceLive.APIEndPoints.register("", "")
        let urlString = value.urlString
        XCTAssertEqual("http://localhost:8000/register", urlString)
    }
    
    func testLoginAPIURL() {
        let value: JournalServiceLive.APIEndPoints = .login("", "")
        let urlString = value.urlString
        XCTAssertEqual("http://localhost:8000/token", urlString)
    }
    
    func testTripWithoutIDAPIURL() {
        let value: JournalServiceLive.APIEndPoints = .trips(.GET, nil , nil, nil)
        let urlString = value.urlString
        XCTAssertEqual("http://localhost:8000/trips", urlString)
    }
    
    func testTripWithIDAPIURL() {
        let value: JournalServiceLive.APIEndPoints = .trips(.GET, 323, nil, nil)
        let urlString = value.urlString
        XCTAssertEqual("http://localhost:8000/trips/323", urlString)
    }
    
    func testEventsWithoutIDAPIURL() {
        let value: JournalServiceLive.APIEndPoints = .events(.GET, nil, nil, nil)
        let urlString = value.urlString
        XCTAssertEqual("http://localhost:8000/events", urlString)
    }
    
    func testEventsWithIDAPIURL() {
        let value: JournalServiceLive.APIEndPoints = .events(.GET, 333, nil, nil)
        let urlString = value.urlString
        XCTAssertEqual("http://localhost:8000/events/333", urlString)
    }
    
    func testMediaWithoutIDAPIURL() {
        let value: JournalServiceLive.APIEndPoints = .media(.POST, nil, nil)
        let urlString = value.urlString
        XCTAssertEqual("http://localhost:8000/media", urlString)
    }
    
    func testMediaWithIDAPIURL() {
        let value: JournalServiceLive.APIEndPoints = .media(.POST, 123, nil)
        let urlString = value.urlString
        XCTAssertEqual("http://localhost:8000/media/123", urlString)
    }
    
    func testCreateRegisterRequestURL() {
        let api = JournalServiceLive.APIEndPoints.register("Hassan", "hassanPassword")
        let request = api.request
        XCTAssertNotNil(request)
        XCTAssertEqual("http://localhost:8000/register", request?.url?.absoluteString)
    }
    
    func testCreateRegisterRequestURLMethod() {
        let api = JournalServiceLive.APIEndPoints.register("Hassan", "hassanPassword")
        let request = api.request
        XCTAssertNotNil(request)
        XCTAssertEqual("POST", request?.httpMethod)
    }

    func testCreateRegisterRequestURLBody() {
        let api = JournalServiceLive.APIEndPoints.register("Hassan", "hassanPassword")
        let request = api.request
        XCTAssertNotNil(request)
        guard let request = request, let body = request.httpBody else {
            XCTFail("Error in handling the request")
            return
        }
        do {
            let body = try JSONDecoder().decode(RegisterUserRequestBody.self, from: body)
            XCTAssertEqual("Hassan", body.userName)
            XCTAssertEqual("hassanPassword", body.password)
        } catch {
            XCTFail("Failed to decode request body")
        }
    }

    // MARK: - Login endpoint tests
    func testCreateLoginRequestURL() {
        let api = JournalServiceLive.APIEndPoints.login("Hassan", "hassanPassword")
        let request = api.request
        XCTAssertNotNil(request)
        XCTAssertEqual("http://localhost:8000/token", request?.url?.absoluteString)
    }
    
    func testCreateLoginRequestURLMethod() {
        let api = JournalServiceLive.APIEndPoints.login("Hassan", "hassanPassword")
        let request = api.request
        XCTAssertNotNil(request)
        XCTAssertEqual("POST", request?.httpMethod)
    }

    func testCreateLoginRequestURLBody() {
        let api = JournalServiceLive.APIEndPoints.login("Hassan", "hassanPassword")
        let request = api.request
        XCTAssertNotNil(request)
        guard let request = request, let body = request.httpBody else {
            XCTFail("Error in handling the request")
            return
        }
        do {
            let body = try JSONDecoder().decode(RegisterUserRequestBody.self, from: body)
            XCTAssertEqual("Hassan", body.userName)
            XCTAssertEqual("hassanPassword", body.password)
        } catch {
            XCTFail("Failed to decode request body")
        }
    }
    
    // MARK: - Trips endpoint tests
    func testTripRequestWithoutIDRequestURL() {
        let api = JournalServiceLive.APIEndPoints.trips(.GET, nil, nil, nil)
        let request = api.request
        XCTAssertNotNil(request)
        XCTAssertEqual("http://localhost:8000/trips", request?.url?.absoluteString)
    }
    
    func testTripRequestWithIDRequestURL() {
        let api = JournalServiceLive.APIEndPoints.trips(.GET, 1, nil, nil)
        let request = api.request
        XCTAssertNotNil(request)
        XCTAssertEqual("http://localhost:8000/trips/1", request?.url?.absoluteString)
    }
    
    // Post request
    func testCreateTripRequestMethod() {
        let tripBody = TripCreate(name: "Trip Name", startDate: Date(), endDate: Date())
        let api = JournalServiceLive.APIEndPoints.trips(.POST, nil, tripBody, nil)
        let request = api.request
        XCTAssertNotNil(request)
        XCTAssertEqual("POST", request?.httpMethod)
    }

    func testCreateTripRequestBody() {
        let currentDate = Date()
        let tripBody = TripCreate(name: "Trip Name", startDate: currentDate, endDate: currentDate)
        let api = JournalServiceLive.APIEndPoints.trips(.POST, nil, tripBody, nil)
        let request = api.request
        XCTAssertNotNil(request)
        guard let request = request, let body = request.httpBody else {
            XCTFail("Error in handling the request")
            return
        }
        do {
            let body = try JSONDecoder().decode(TripCreate.self, from: body)
            XCTAssertEqual("Trip Name", body.name)
            XCTAssertEqual(currentDate, body.startDate)
            XCTAssertEqual(currentDate, body.endDate)
        } catch {
            XCTFail("Failed to decode request body")
        }
    }
    
    // Delete Request
    func testDeleteTripRequestMethod() {
        let api = JournalServiceLive.APIEndPoints.trips(.DELETE, 1, nil, nil)
        let request = api.request
        XCTAssertNotNil(request)
        XCTAssertEqual("DELETE", request?.httpMethod)
    }
    
    // Put Request
    func testUpdateTripRequestMethod() {
        let tripBody = TripUpdate(name: "Trip Name", startDate: Date(), endDate: Date())
        let api = JournalServiceLive.APIEndPoints.trips(.PUT, 1, nil, tripBody)
        let request = api.request
        XCTAssertNotNil(request)
        XCTAssertEqual("PUT", request?.httpMethod)
    }

    func testUpdateTripRequestBody() {
        let currentDate = Date()
        let tripBody = TripUpdate(name: "Trip Name", startDate: currentDate, endDate: currentDate)
        let api = JournalServiceLive.APIEndPoints.trips(.PUT, 123, nil, tripBody)
        let request = api.request
        XCTAssertNotNil(request)
        guard let request = request, let body = request.httpBody else {
            XCTFail("Error in handling the request")
            return
        }
        do {
            let body = try JSONDecoder().decode(TripUpdate.self, from: body)
            XCTAssertEqual("Trip Name", body.name)
            XCTAssertEqual(currentDate, body.startDate)
            XCTAssertEqual(currentDate, body.endDate)
        } catch {
            XCTFail("Failed to decode request body")
        }
    }
    
    // MARK: - Events endpoint tests
    func testEventsRequestWithoutIDRequestURL() {
        let api = JournalServiceLive.APIEndPoints.events(.GET, nil, nil, nil)
        let request = api.request
        XCTAssertNotNil(request)
        XCTAssertEqual("http://localhost:8000/events", request?.url?.absoluteString)
    }
    
    func testEventsRequestWithIDRequestURL() {
        let api = JournalServiceLive.APIEndPoints.events(.GET, 1, nil, nil)
        let request = api.request
        XCTAssertNotNil(request)
        XCTAssertEqual("http://localhost:8000/events/1", request?.url?.absoluteString)
    }
    
    // Post request
    func testCreateEventsRequestMethod() {
        let currentDate = Date()
        let eventBody = EventCreate(tripId: 1, name: "Event 1", note: "Event Note 1", date: currentDate, location: Location(latitude: 1.0, longitude: 1.0), transitionFromPrevious: "No")
        let api = JournalServiceLive.APIEndPoints.events(.POST, nil, eventBody, nil)
        let request = api.request
        XCTAssertNotNil(request)
        XCTAssertEqual("POST", request?.httpMethod)
    }

    func testCreateEventsRequestBody() {
        let currentDate = Date()
        let eventBody = EventCreate(tripId: 1, name: "Event 1", note: "Event Note 1", date: currentDate, location: Location(latitude: 1.0, longitude: 2.0), transitionFromPrevious: "No")
        let api = JournalServiceLive.APIEndPoints.events(.POST, nil, eventBody, nil)
        let request = api.request
        XCTAssertNotNil(request)
        guard let request = request, let body = request.httpBody else {
            XCTFail("Error in handling the request")
            return
        }
        do {
            let body = try JSONDecoder().decode(EventCreate.self, from: body)
            XCTAssertEqual(1, body.tripId)
            XCTAssertEqual("Event 1", body.name)
            XCTAssertEqual("Event Note 1", body.note)
            XCTAssertEqual(currentDate, body.date)
            let location = body.location
            XCTAssertEqual(1.0, location?.latitude)
            XCTAssertEqual(2.0, location?.longitude)
            XCTAssertEqual("No", body.transitionFromPrevious)
        } catch {
            XCTFail("Failed to decode request body")
        }
    }
    
    // Delete Request
    func testDeleteEventsRequestMethod() {
        let api = JournalServiceLive.APIEndPoints.events(.DELETE, 1, nil, nil)
        let request = api.request
        XCTAssertNotNil(request)
        XCTAssertEqual("DELETE", request?.httpMethod)
    }
    
    // Put Request
    func testUpdateEventsRequestMethod() {
        let currentDate = Date()
        let eventBody = EventUpdate(name: "Event 1",note: "Event Note 1" ,date: currentDate, location: Location(latitude: 1.0, longitude: 2.0), transitionFromPrevious: "No")
        let api = JournalServiceLive.APIEndPoints.events(.PUT, 1, nil, eventBody)
        let request = api.request
        XCTAssertNotNil(request)
        XCTAssertEqual("PUT", request?.httpMethod)
    }

    func testUpdateEventsRequestBody() {
        let currentDate = Date()
        let eventBody = EventUpdate(name: "Event 1",note: "Event Note 1" ,date: currentDate, location: Location(latitude: 1.0, longitude: 2.0), transitionFromPrevious: "No")
        let api = JournalServiceLive.APIEndPoints.events(.PUT, 123, nil, eventBody)
        let request = api.request
        XCTAssertNotNil(request)
        guard let request = request, let body = request.httpBody else {
            XCTFail("Error in handling the request")
            return
        }
        do {
            let body = try JSONDecoder().decode(EventUpdate.self, from: body)
            XCTAssertEqual("Event 1", body.name)
            XCTAssertEqual("Event Note 1", body.note)
            XCTAssertEqual(currentDate, body.date)
            let location = body.location
            XCTAssertEqual(1.0, location?.latitude)
            XCTAssertEqual(2.0, location?.longitude)
            XCTAssertEqual("No", body.transitionFromPrevious)
        } catch {
            XCTFail("Failed to decode request body")
        }
    }
    
    // MARK: - Media Tests
    func testMediaRequestWithoutIDRequestURL() {
        let mediaBody = MediaCreate(eventId: 11, caption: "Hello", base64Data: "media data".data(using: .utf8)!)
        let api = JournalServiceLive.APIEndPoints.media(.POST, nil, mediaBody)
        let request = api.request
        XCTAssertNotNil(request)
        XCTAssertEqual("http://localhost:8000/media", request?.url?.absoluteString)
    }
    
    func testMediaRequestWithIDRequestURL() {
        let api = JournalServiceLive.APIEndPoints.media(.DELETE, 1, nil)
        let request = api.request
        XCTAssertNotNil(request)
        XCTAssertEqual("http://localhost:8000/media/1", request?.url?.absoluteString)
    }
    
    // Post request
    func testCreateMediaRequestMethod() {
        let mediaBody = MediaCreate(eventId: 11, caption: "Hello", base64Data: "media data".data(using: .utf8)!)
        let api = JournalServiceLive.APIEndPoints.media(.POST, nil, mediaBody)
        let request = api.request
        XCTAssertNotNil(request)
        XCTAssertEqual("POST", request?.httpMethod)
    }

    func testCreateMediaRequestBody() {
        let mediaBody = MediaCreate(eventId: 11, caption: "Hello", base64Data: "media data".data(using: .utf8)!)
        let api = JournalServiceLive.APIEndPoints.media(.POST, nil, mediaBody)
        let request = api.request
        XCTAssertNotNil(request)
        guard let request = request, let body = request.httpBody else {
            XCTFail("Error in handling the request")
            return
        }
        do {
            let body = try JSONDecoder().decode(MediaCreate.self, from: body)
            XCTAssertEqual(11, body.eventId)
            XCTAssertEqual("Hello", body.caption)
            let dataString = String(data: body.base64Data, encoding: .utf8)
            XCTAssertEqual("media data", dataString)
        } catch {
            XCTFail("Failed to decode request body")
        }
    }
    
    // Delete Request
    func testDeleteMediaRequestMethod() {
        let api = JournalServiceLive.APIEndPoints.media(.DELETE, 1, nil)
        let request = api.request
        XCTAssertNotNil(request)
        XCTAssertEqual("DELETE", request?.httpMethod)
    }
}
