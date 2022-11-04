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
        let breedsString = animal.breeds.unknown ? "unknown" : [animal.breeds.primary ?? "", animal.breeds.secondary ?? "", ].joined(separator: ",")
        return breedsString
    }
    var thumbnailURL: URL? {
        return animal.imageURL?.small
    }
    
    init (animal: Animal) {
        self.animal = animal
    }
}
