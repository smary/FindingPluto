//
//  RequestProtocol.swift
//  FindingPluto
//
//  Created by Mariana on 03.11.2022.
//

import Foundation


enum RequestType: String {
    case GET
    case POST
}

protocol RequestProtocol {
    
    var path: String { get }
    var requestType: RequestType { get }
    var headers: [String: String] { get }
    var params: [String: Any] { get }
    var urlParams: [String: String?] { get }
    var addAuthorizationToken: Bool { get }
    
}

extension RequestProtocol {
    
    var host: String {
        PetFinderAPIConstants.host
    }
    var addAuthorizationToken: Bool {
        true
    }
    var params: [String: Any] {
        [:]
    }
    var urlParams: [String: String?] {
        [:]
    }
    var headers: [String: String] {
        [:]
    }
    
    func createURLRequest(authToken: String) throws -> URLRequest {
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.path = path
        
        if !urlParams.isEmpty {
            components.queryItems = urlParams.map { URLQueryItem(name: $0, value: $1) }
        }
        
        guard let url = components.url else { throw  NetworkError.invalidURL }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = requestType.rawValue
        
        if !headers.isEmpty {
            urlRequest.allHTTPHeaderFields = headers
        }
        if addAuthorizationToken {
            urlRequest.setValue(authToken, forHTTPHeaderField: "Authorization")
        }
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if !params.isEmpty {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params)
        }
        
        return urlRequest
    }
}

enum AuthTokenRequest: RequestProtocol {
    
    case auth
    var path: String {
        "/v2/oauth2/token"
    }
    var params: [String: Any] {
        [
            "grant_type": PetFinderAPIConstants.grant_type,
            "client_id": PetFinderAPIConstants.client_id,
            "client_secret": PetFinderAPIConstants.client_secret
        ]
    }
    var addAuthorizationToken: Bool {
        false
    }
    var requestType: RequestType {
        .POST
    }
}

enum AnimalsRequest: RequestProtocol {
    
    case getAnimalsList
    var path: String {
        "/v2/animals"
    }
    var requestType: RequestType {
        .GET
    }
}
