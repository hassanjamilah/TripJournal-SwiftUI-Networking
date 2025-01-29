//
//  JournalService+Live.swift
//  TripJournal
//
//  Created by Hassan Jamila on 17/1/25.
//

import Foundation
import Combine

class JournalServiceLive: JournalService {
    
    enum HttpMethod: String {
        case POST = "POST"
        case GET = "GET"
        case DELETE = "DELETE"
        case PUT = "PUT"
    }
    
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
        
        case register(String, String)
        case login(String, String)
        case trips(HttpMethod, String?, TripCreate?)
        case events(HttpMethod, String?, EventCreate?)
        case media(HttpMethod, String?, MediaCreate?)
        
        var urlString: String {
            switch self {
            case .register:
                return "\(APIEndPoints.BASE_URL)/register"
            case .login:
                return "\(APIEndPoints.BASE_URL)/token"
            case let .trips(_ , tripID, _):
                guard let tripID = tripID else {
                    return "\(APIEndPoints.BASE_URL)/trips"
                }
                return "\(APIEndPoints.BASE_URL)/trips/\(tripID)"
            case let .events(_, eventID, _):
                guard let eventID = eventID else {
                    return "\(APIEndPoints.BASE_URL)/events"
                }
                return "\(APIEndPoints.BASE_URL)/events/\(eventID)"
            case let .media(httpMethod, mediaID, mediaBody):
                guard let mediaID = mediaID else {
                    return "\(APIEndPoints.BASE_URL)/media"
                }
                return "\(APIEndPoints.BASE_URL)/media/\(mediaID)"
            }
        }
        
        var url: URL {
            URL(string: self.urlString)!
        }
        
        var request: URLRequest? {
            switch self {
            case let .register(userName, password):
                return createRegisterRequest(userName: userName, password: password)
            case let .login(userName, password):
                return createLoginRequest(userName: userName, password: password)
            case let .trips(httpMethod, tripID, tripBody):
                return createTripsRequest(httpMethod: httpMethod, tripID: tripID, tripBody: tripBody)
            case let .events(httpMethod, eventID, eventBody):
                return createEventsRequest(httpMethod: httpMethod, eventID: eventID, eventBody: eventBody)
            case let .media(httpMethod, mediaID, mediaBody):
                return createMediaRequest(httpMethod: httpMethod, mediaID: mediaID, mediaBody: mediaBody)
            default:
                return nil
                break
                
            }
        }
                                         
        func createRegisterRequest(userName: String, password: String) -> URLRequest? {
            var request = URLRequest(url: self.url)
            let body = RegisterUserRequestBody(userName: userName, password: password)
            request.httpMethod = HttpMethod.POST.rawValue
            setRequestBody(request: &request, body: body)
            guard let _ = request.httpBody else {
                return nil
            }
            return request
        }
        
        func createLoginRequest(userName: String, password: String) -> URLRequest? {
            var request = URLRequest(url: self.url)
            let body = RegisterUserRequestBody(userName: userName, password: password)
            request.httpMethod = HttpMethod.POST.rawValue
            setRequestBody(request: &request, body: body)
            guard let _ = request.httpBody else {
                return nil
            }
            return request
        }

        func createTripsRequest(httpMethod: HttpMethod, tripID: String?, tripBody: TripCreate?) -> URLRequest? {
            switch httpMethod {
            case .POST:
                guard let tripBody = tripBody else {
                    return nil
                }
                var request = URLRequest(url: self.url)
                request.httpMethod = HttpMethod.POST.rawValue
                setRequestBody(request: &request, body: tripBody)
                guard let _ = request.httpBody else {
                    return nil
                }
                return request
            case .GET:
                var request = URLRequest(url: self.url)
                request.httpMethod = HttpMethod.GET.rawValue
                return request
            case .DELETE:
                guard let _ = tripID else {
                    return nil
                }
                var request = URLRequest(url: self.url)
                request.httpMethod = HttpMethod.DELETE.rawValue
                return request
            case .PUT:
                guard let _ = tripID, let tripBody = tripBody else {
                    return nil
                }
                var request = URLRequest(url: self.url)
                request.httpMethod = HttpMethod.PUT.rawValue
                setRequestBody(request: &request, body: tripBody)
                guard let _ = request.httpBody else {
                    return nil
                }
                return request
            }
        }
        
        func createEventsRequest(httpMethod: HttpMethod, eventID: String?, eventBody: EventCreate?) -> URLRequest? {
            switch httpMethod {
            case .POST:
                guard let eventBody = eventBody else {
                    return nil
                }
                var request = URLRequest(url: self.url)
                request.httpMethod = HttpMethod.POST.rawValue
                setRequestBody(request: &request, body: eventBody)
                guard let _ = request.httpBody else {
                    return nil
                }
                return request
            case .GET:
                var request = URLRequest(url: self.url)
                request.httpMethod = HttpMethod.GET.rawValue
                return request
            case .DELETE:
                guard let _ = eventID else {
                    return nil
                }
                var request = URLRequest(url: self.url)
                request.httpMethod = HttpMethod.DELETE.rawValue
                return request
            case .PUT:
                guard let _ = eventID, let eventBody = eventBody else {
                    return nil
                }
                var request = URLRequest(url: self.url)
                request.httpMethod = HttpMethod.PUT.rawValue
                setRequestBody(request: &request, body: eventBody)
                guard let _ = request.httpBody else {
                    return nil
                }
                return request
            }
        }
        
        func createMediaRequest(httpMethod: HttpMethod, mediaID: String?, mediaBody: MediaCreate?) -> URLRequest? {
            switch httpMethod {
            case .POST:
                guard let mediaBody = mediaBody else {
                    return nil
                }
                var request = URLRequest(url: self.url)
                request.httpMethod = HttpMethod.POST.rawValue
                setRequestBody(request: &request, body: mediaBody)
                guard let _ = request.httpBody else {
                    return nil
                }
                return request
            case .DELETE:
                guard let _ = mediaID else {
                    return nil
                }
                var request = URLRequest(url: self.url)
                request.httpMethod = HttpMethod.DELETE.rawValue
                return request
            default:
                return nil
            }
        }
        
        func setRequestBody( request: inout URLRequest, body: Codable) {
            do {
                request.httpBody = try JSONEncoder().encode(body)
            } catch {
                print("Error in encoding the request body")
            }
        }
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

