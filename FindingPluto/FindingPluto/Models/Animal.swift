//
//  Animal.swift
//  FindingPluto
//
//  Created by Mariana on 04.11.2022.
//

import Foundation


struct AnimalsResponse: Decodable {
    let animals : [Animal]?
}

struct Animal : Decodable {
    let name : String?
    let breeds: Breed
    let size: String?
    let gender: String?
    let status: String?
    let distance: Int?
    let imageURL: PrimaryPhoto?
    
    enum CodingKeys: String, CodingKey {
        case name
        case breeds
        case size
        case gender
        case status
        case distance
        case imageURL = "primary_photo_cropped"
    }
    
    init() {
        self.name = ""
        self.gender = ""
        self.status = ""
        self.size = ""
        self.distance = 0
        self.imageURL = PrimaryPhoto(small: URL(string: ""))
        self.breeds = Breed()
        
    }
}

struct PrimaryPhoto: Decodable {
    let small: URL?
}

struct Breed: Decodable {
    let primary: String?
    let secondary: String?
    let mixed: Bool
    let unknown: Bool
    
    init() {
        self.primary = ""
        self.secondary = ""
        self.mixed = false
        self.unknown = true
    }
}
