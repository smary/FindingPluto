//
//  PetFinderAPI.swift
//  FindingPluto
//
//  Created by Mariana on 31.10.2022.
//

import Foundation
import RxSwift
import RxCocoa

class PetFinderAPIConstants {
    
    static let client_id = "v8RjyQt1CPQx5ApIJBweYYou6K7fbPPalE6rem8QzbkJ5BYFTJ"
    static let client_secret = "IMauhBOrO6rHY2oaII2VwvZAjVbWlAeL2RcBCJYb"
    static let grant_type = "client_credentials"
    static let host = "api.petfinder.com"
}

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
            return "Invalid acces token."
        case .invalidResponse:
            return "The server returned an invalid response."
        case .invalidURL:
            return "URL string is not valid."
        }
    }
}
