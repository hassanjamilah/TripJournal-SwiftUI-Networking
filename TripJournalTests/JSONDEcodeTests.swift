//
//  JSONDEcodeTests.swift
//  TripJournalTests
//
//  Created by Hassan Jamila on 31/1/25.
//

import XCTest
@testable import TripJournal

final class JSONDEcodeTests: XCTestCase {
    func testParseTripsResponse() throws {
        let mockTrips = """
        [{
            "name": "Trip 1",
            "start_date": "1994-01-31T06:20:47Z",
            "end_date": "1994-01-31T06:20:47Z",
            "id": 1,
            "events": []
        }]
        """.data(using: .utf8)!
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let result = try decoder.decode([Trip].self, from: mockTrips)
            print(result)
        } catch {
            XCTFail("Bad JSON \(error)")
        }
        
        
    }
}
