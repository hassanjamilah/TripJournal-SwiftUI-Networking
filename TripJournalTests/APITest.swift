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
        let value: JournalServiceLive.APIEndPoints = .register
        let urlString = value.urlString
        XCTAssertEqual("http://localhost:8000/register", urlString)
    }
    
    func testLoginAPIURL() {
        let value: JournalServiceLive.APIEndPoints = .login
        let urlString = value.urlString
        XCTAssertEqual("http://localhost:8000/token", urlString)
    }
    
    func testTripWithoutIDAPIURL() {
        let value: JournalServiceLive.APIEndPoints = .trip(nil)
        let urlString = value.urlString
        XCTAssertEqual("http://localhost:8000/trips", urlString)
    }
    
    func testTripWithIDAPIURL() {
        let value: JournalServiceLive.APIEndPoints = .trip("323")
        let urlString = value.urlString
        XCTAssertEqual("http://localhost:8000/trips/323", urlString)
    }
    
    func testEventsWithoutIDAPIURL() {
        let value: JournalServiceLive.APIEndPoints = .events(nil)
        let urlString = value.urlString
        XCTAssertEqual("http://localhost:8000/events", urlString)
    }
    
    func testEventsWithIDAPIURL() {
        let value: JournalServiceLive.APIEndPoints = .events("333")
        let urlString = value.urlString
        XCTAssertEqual("http://localhost:8000/events/333", urlString)
    }
    
    func testMediaWithoutIDAPIURL() {
        let value: JournalServiceLive.APIEndPoints = .media(nil)
        let urlString = value.urlString
        XCTAssertEqual("http://localhost:8000/media", urlString)
    }
    
    func testMediaWithIDAPIURL() {
        let value: JournalServiceLive.APIEndPoints = .media("123")
        let urlString = value.urlString
        XCTAssertEqual("http://localhost:8000/media/123", urlString)
    }
    
    
}
