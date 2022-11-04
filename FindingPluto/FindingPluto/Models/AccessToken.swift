//
//  AccessToken.swift
//  FindingPluto
//
//  Created by Mariana on 04.11.2022.
//

import Foundation

struct AccessToken: Codable {
    var tokenType: String
    var expiresIn: Int
    var token: String
    private let requestDate = Date()
    
    enum CodingKeys: String, CodingKey {
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case token = "access_token"
    }
}

extension AccessToken {
    
    var expiresAt: Date {
        Calendar.current.date(byAdding: .second, value: expiresIn, to: requestDate) ?? Date()
    }
    
    var bearerAccessToken: String {
        "\(tokenType) \(token)"
    }
}
