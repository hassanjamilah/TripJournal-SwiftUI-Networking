//
//  JournalService+Live.swift
//  TripJournal
//
//  Created by Hassan Jamila on 17/1/25.
//

import Foundation
import Combine

class JournalServiceLive: JournalService {
    
    var tokenExpired = false
    @Published var token: String?
    
    
    
    var isAuthenticated: AnyPublisher<Bool, Never> {
        $token
            .map {$0 != nil}
            .eraseToAnyPublisher()
    }
    
    enum APIError: Error {
        case BAD_REQUEST
        case NO_DATA
    }
    
    enum APIEndPoints {
        static let BASE_URL = "http://localhost:8000"
        
        case register
        case login
        case trip(String?)
        case events(String?)
        case media(String?)
        
        var urlString: String {
            switch self {
            case .register:
                return "\(APIEndPoints.BASE_URL)/register"
            case .login:
                return "\(APIEndPoints.BASE_URL)/token"
            case let .trip(tripID):
                guard let tripID = tripID else {
                    return "\(APIEndPoints.BASE_URL)/trips"
                }
                return "\(APIEndPoints.BASE_URL)/trips/\(tripID)"
            case let .events(eventID):
                guard let eventID = eventID else {
                    return "\(APIEndPoints.BASE_URL)/events"
                }
                return "\(APIEndPoints.BASE_URL)/events/\(eventID)"
            case let .media(mediaID):
                guard let mediaID = mediaID else {
                    return "\(APIEndPoints.BASE_URL)/media"
                }
                return "\(APIEndPoints.BASE_URL)/media/\(mediaID)"
            }
        }
        
        
        // TODO: Create the requests
//        var request: URLRequest {
////            switch self {
////            case .register:
////                <#code#>
////            case .login:
////                <#code#>
////            case .trip(let string):
////                <#code#>
////            case .events(let string):
////                <#code#>
////            case .media(let string):
////                <#code#>
////            }
//
//        }
//    
    }
    
    func register(username: String, password: String) async throws -> Token {
//        let request = URLRequest(url: "sdfsd")
        return Token(accessToken: "", tokenType: "")
    }
    
    func logIn(username: String, password: String) async throws -> Token {
        return Token(accessToken: "", tokenType: "")
    }
    
    func logOut() {
        
    }
    
    func createTrip(with request: TripCreate) async throws -> Trip {
        return Trip(id: 3432, name: "", startDate: Date(), endDate: Date(), events: [])
    }
    
    func getTrips() async throws -> [Trip] {
        return []
    }
    
    func getTrip(withId tripId: Trip.ID) async throws -> Trip {
        return Trip(id: 32432, name: "", startDate: Date(), endDate: Date(), events: [])
    }
    
    func updateTrip(withId tripId: Trip.ID, and request: TripUpdate) async throws -> Trip {
        return Trip(id: 32432, name: "", startDate: Date(), endDate: Date(), events: [])
    }
    
    func deleteTrip(withId tripId: Trip.ID) async throws {
        
    }
    
    func createEvent(with request: EventCreate) async throws -> Event {
        return Event(id: 33432, name: "", date: Date(), medias: [])
    }
    
    func updateEvent(withId eventId: Event.ID, and request: EventUpdate) async throws -> Event {
        return Event(id: 33432, name: "", date: Date(), medias: [])
    }
    
    func deleteEvent(withId eventId: Event.ID) async throws {
        
    }
    
    func createMedia(with request: MediaCreate) async throws -> Media {
        return Media(id: 2423, url: nil)
    }
    
    func deleteMedia(withId mediaId: Media.ID) async throws {
        
    }
    
    
}

