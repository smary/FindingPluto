//
//  NetworkError.swift
//  FindingPluto
//
//  Created by Mariana on 05.11.2022.
//

import Foundation

public enum NetworkError: Error {
    
    case invalidRequest         // Status code 400
    case unauthorized           // Status code 401
    case invalidResponse
    case invalidURL
    
    public var errorDescription: String? {
        switch self {
        case.invalidRequest:
            return "Invalid request."
        case .unauthorized:
            return "Invalid credentials or access token."
        case .invalidResponse:
            return "Invalid response from server."
        case .invalidURL:
            return "URL string is malformed."
        }
    }
}
