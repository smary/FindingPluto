//
//  Models.swift
//  FindingPluto
//
//  Created by Mariana on 30.10.2022.
//

import Foundation

struct AccessToken: Codable {
    var tokenType: String
    var expiresIn: Int
    var accessToken: String
}


struct AnimalsResponse: Decodable {
    let animals : [Animal]?
}

struct Animal : Decodable {
    let name : String?
//    let breeds: String? //TODO: Map "breeds"
    let size: String?
    let gender: String?
    let status: String?
    let distance: Int?
}

