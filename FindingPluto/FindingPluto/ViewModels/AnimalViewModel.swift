//
//  AnimalViewModel.swift
//  FindingPluto
//
//  Created by Mariana on 04.11.2022.
//

import Foundation
import RxSwift
import RxRelay

struct AnimalViewModel {
    private let animal: Animal
    
    var name: String {
        return animal.name ?? ""
    }
    var breed: String {
        let breedsString = animal.breeds.unknown ? "unknown" : [animal.breeds.primary ?? "", animal.breeds.secondary ?? "", ].joined(separator: " ")
        return breedsString
    }
    var thumbnailURLString: String {
        if let urlString = animal.imageURL?.small?.absoluteString {
            return urlString
        }
        return ""
    }
    
    var status: String {
        return animal.status ?? ""
    }
    
    var gender: String {
        return animal.gender ?? ""
    }
    
    var size: String {
        return animal.size ?? ""
    }
    
    var distance: Int {
        return animal.distance ?? 0
    }
    
    init (animal: Animal) {
        self.animal = animal
    }
}
