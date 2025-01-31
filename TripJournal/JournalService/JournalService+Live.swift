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
    @Published var token: Token?
    
    
    
    var isAuthenticated: AnyPublisher<Bool, Never> {
        $token
            .map {$0 != nil}
            .eraseToAnyPublisher()
    }
    
    enum APIError: Error {
        case BAD_REQUEST
        case NO_DATA
        case BAD_RESPONSE
        case BAD_JSON_RESPONSE
    }
    
    enum APIEndPoints {
        static let BASE_URL = "http://localhost:8000"
        
        case register(String, String)
        case login(String, String)
        case trips(HttpMethod, Int?, TripCreate?, TripUpdate?, Token?)
        case events(HttpMethod, Int?, EventCreate?, EventUpdate?, Token?)
        case media(HttpMethod, Int?, MediaCreate?, Token?)
        
        var urlString: String {
            switch self {
            case .register:
                return "\(APIEndPoints.BASE_URL)/register"
            case .login:
                return "\(APIEndPoints.BASE_URL)/token"
            case let .trips(_ , tripID, _, _, _):
                guard let tripID = tripID else {
                    return "\(APIEndPoints.BASE_URL)/trips"
                }
                return "\(APIEndPoints.BASE_URL)/trips/\(tripID)"
            case let .events(_, eventID, _, _, _):
                guard let eventID = eventID else {
                    return "\(APIEndPoints.BASE_URL)/events"
                }
                return "\(APIEndPoints.BASE_URL)/events/\(eventID)"
            case let .media(_, mediaID, _, _):
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
            case let .trips(httpMethod, tripID, tripBody, tripUpdateBody, token):
                return createTripsRequest(httpMethod: httpMethod, tripID: tripID, tripBody: tripBody, tripUpdateBody: tripUpdateBody, token: token)
            case let .events(httpMethod, eventID, eventBody, eventUpdateBody, token):
                return createEventsRequest(httpMethod: httpMethod, eventID: eventID, eventBody: eventBody, eventUpdateBody: eventUpdateBody, token: token)
            case let .media(httpMethod, mediaID, mediaBody, token):
                return createMediaRequest(httpMethod: httpMethod, mediaID: mediaID, mediaBody: mediaBody, token: token)
            }
        }
                                         
        func createRegisterRequest(userName: String, password: String) -> URLRequest? {
            var request = URLRequest(url: self.url)
            let body = RegisterUserRequestBody(userName: userName, password: password)
            request.httpMethod = HttpMethod.POST.rawValue
            setRequestBody(request: &request, body: body, token: nil)
            guard let _ = request.httpBody else {
                return nil
            }
            return request
        }
        
        func createLoginRequest(userName: String, password: String) -> URLRequest? {
            var request = URLRequest(url: self.url)
            request.addValue("JSON", forHTTPHeaderField: "accept")
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            let loginData = "grant_type=&username=\(userName)&password=\(password)"
            request.httpBody = loginData.data(using: .utf8)
            request.httpMethod = HttpMethod.POST.rawValue
            
            guard let _ = request.httpBody else {
                return nil
            }
            return request
        }

        func createTripsRequest(httpMethod: HttpMethod, tripID: Int?, tripBody: TripCreate?, tripUpdateBody: TripUpdate?, token: Token?) -> URLRequest? {
            switch httpMethod {
            case .POST:
                guard let tripBody = tripBody else {
                    return nil
                }
                var request = URLRequest(url: self.url)
                request.httpMethod = HttpMethod.POST.rawValue
                setRequestBody(request: &request, body: tripBody, token: token)
                guard let _ = request.httpBody else {
                    return nil
                }
                return request
            case .GET:
                var request = URLRequest(url: self.url)
                setRequestHeaders(request: &request, token: token)
                request.httpMethod = HttpMethod.GET.rawValue
                return request
            case .DELETE:
                guard let _ = tripID else {
                    return nil
                }
                var request = URLRequest(url: self.url)
                setRequestHeaders(request: &request, token: token)
                request.httpMethod = HttpMethod.DELETE.rawValue
                return request
            case .PUT:
                guard let _ = tripID, let tripBody = tripUpdateBody else {
                    return nil
                }
                var request = URLRequest(url: self.url)
                request.httpMethod = HttpMethod.PUT.rawValue
                setRequestBody(request: &request, body: tripBody, token: token)
                guard let _ = request.httpBody else {
                    return nil
                }
                return request
            }
        }
        
        func createEventsRequest(httpMethod: HttpMethod, eventID: Int?, eventBody: EventCreate?, eventUpdateBody: EventUpdate?, token: Token?) -> URLRequest? {
            switch httpMethod {
            case .POST:
                guard let eventBody = eventBody else {
                    return nil
                }
                var request = URLRequest(url: self.url)
                request.httpMethod = HttpMethod.POST.rawValue
                setRequestBody(request: &request, body: eventBody, token: token)
                guard let _ = request.httpBody else {
                    return nil
                }
                return request
            case .GET:
                var request = URLRequest(url: self.url)
                request.httpMethod = HttpMethod.GET.rawValue
                setRequestHeaders(request: &request, token: token)
                return request
            case .DELETE:
                guard let _ = eventID else {
                    return nil
                }
                var request = URLRequest(url: self.url)
                request.httpMethod = HttpMethod.DELETE.rawValue
                setRequestHeaders(request: &request, token: token)
                return request
            case .PUT:
                guard let _ = eventID, let eventBody = eventUpdateBody else {
                    return nil
                }
                var request = URLRequest(url: self.url)
                request.httpMethod = HttpMethod.PUT.rawValue
                setRequestBody(request: &request, body: eventBody, token: token)
                guard let _ = request.httpBody else {
                    return nil
                }
                return request
            }
        }
        
        func createMediaRequest(httpMethod: HttpMethod, mediaID: Int?, mediaBody: MediaCreate?, token: Token?) -> URLRequest? {
            switch httpMethod {
            case .POST:
                guard let mediaBody = mediaBody else {
                    return nil
                }
                var request = URLRequest(url: self.url)
                request.httpMethod = HttpMethod.POST.rawValue
                setRequestBody(request: &request, body: mediaBody, token: token)
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
                setRequestHeaders(request: &request, token: token)
                return request
            default:
                return nil
            }
        }
        
        func setRequestBody( request: inout URLRequest, body: Codable, token: Token?) {
            do {
                setRequestHeaders(request: &request, token: token)
                request.httpBody = try JSONEncoder().encode(body)
            } catch {
                print("Error in encoding the request body")
            }
        }
        
        func setRequestHeaders(request: inout URLRequest, token: Token?) {
            request.addValue("application/json", forHTTPHeaderField: "accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            if let token = token  {
                request.setValue("Bearer \(token.accessToken)", forHTTPHeaderField: "Authorization")
            }
        }
    }
    
    func register(username: String, password: String) async throws -> Token {
        let request = APIEndPoints.register(username, password).request
        let token: Token = try await doNetworkRequest(request: request)
        self.token = token
        return token
    }
    
    func logIn(username: String, password: String) async throws -> Token {
        let request = APIEndPoints.login(username, password).request
        let token: Token = try await doNetworkRequest(request: request)
        self.token = token
        return token
    }
    
    func logOut() {
        token = nil
    }
    
    func createTrip(with request: TripCreate) async throws -> Trip {
        let request = APIEndPoints.trips(.POST, nil, request, nil, token).request
        return try await doNetworkRequest(request: request)
    }
    
    func getTrips() async throws -> [Trip] {
        let request = APIEndPoints.trips(.GET, nil, nil, nil, token).request
        return try await doNetworkRequest(request: request)
    }
    
    func getTrip(withId tripId: Trip.ID) async throws -> Trip {
        let request = APIEndPoints.trips(.GET, tripId, nil, nil, token).request
        return try await doNetworkRequest(request: request)
    }
    
    func updateTrip(withId tripId: Trip.ID, and request: TripUpdate) async throws -> Trip {
        let request = APIEndPoints.trips(.PUT, tripId, nil, request, token).request
        return try await doNetworkRequest(request: request)
    }
    
    func deleteTrip(withId tripId: Trip.ID) async throws {
        if let request = APIEndPoints.trips(.DELETE, tripId, nil, nil, token).request {
            let (_, _) = try await URLSession.shared.data(for: request)
        }
    }
    
    func createEvent(with request: EventCreate) async throws -> Event {
        let request = APIEndPoints.events(.POST, nil, request, nil, token).request
        return try await doNetworkRequest(request: request)
    }
    
    func updateEvent(withId eventId: Event.ID, and request: EventUpdate) async throws -> Event {
        let request = APIEndPoints.events(.PUT, eventId, nil, request, token).request
        return try await doNetworkRequest(request: request)
    }
    
    func deleteEvent(withId eventId: Event.ID) async throws {
        if let request = APIEndPoints.events(.DELETE, eventId, nil, nil, token).request {
            let (_, _) = try await URLSession.shared.data(for: request)
        }
    }
    
    func createMedia(with request: MediaCreate) async throws -> Media {
        let request = APIEndPoints.media(.POST, nil, request, token).request
        return try await doNetworkRequest(request: request)
    }
    
    func deleteMedia(withId mediaId: Media.ID) async throws {
        if let request = APIEndPoints.media(.DELETE, mediaId, nil, token).request {
            let (_, _) = try await URLSession.shared.data(for: request)
        }
    }
    
    func doNetworkRequest<T: Codable>(request: URLRequest?) async throws -> T {
        do {
            guard let request = request else {
                throw APIError.BAD_REQUEST
            }
                        
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw APIError.BAD_RESPONSE
            }
            let token = try JSONDecoder().decode(T.self, from: data)
            return token
        } catch {
            throw APIError.BAD_JSON_RESPONSE
        }
    }
    
    
}

