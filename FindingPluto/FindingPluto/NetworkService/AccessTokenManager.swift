//
//  AccessTokenManager.swift
//  FindingPluto
//
//  Created by Mariana on 03.11.2022.
//

import Foundation


protocol AccessTokenManagerProtocol {
    
    func isAccessTokenValid() -> Bool
    func fetchAccessToken() -> String
    func refreshWith(accessToken: AccessToken) throws
}

class AccessTokenManager {
    
    private var userDefaults: UserDefaults = .standard
    private var accessToken: String?
    private var expiresAt = Date()
    
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
    
    enum TokenUserDefaultsKeys {
        static let expiresAt = "expiresAt"
        static let accessToken = "accessToken"
    }
    
    func save(accessToken: AccessToken) {
        userDefaults.set(accessToken.expiresAt.timeIntervalSince1970, forKey: TokenUserDefaultsKeys.expiresAt)
        userDefaults.set(accessToken.token, forKey: TokenUserDefaultsKeys.accessToken)
    }
    
    func getToken() -> String? {
        userDefaults.string(forKey: TokenUserDefaultsKeys.accessToken)
    }
    
    func getExpirationDate() -> Date {
        Date(timeIntervalSince1970: userDefaults.double(forKey: TokenUserDefaultsKeys.expiresAt))
    }
}

extension AccessTokenManager: AccessTokenManagerProtocol {
    
    func isAccessTokenValid() -> Bool {
        accessToken = getToken()
        expiresAt = getExpirationDate()
        return accessToken != nil && expiresAt.compare(Date()) == .orderedDescending
    }
    
    func fetchAccessToken() -> String {
        guard let token = accessToken else {
            return ""
        }
        return token
    }
    
    func refreshWith(accessToken: AccessToken) throws {
        let expiresAt = accessToken.expiresAt
        let token = accessToken.token
        
        save(accessToken: accessToken)
        self.expiresAt = expiresAt
        self.accessToken = token
    }
    
}
