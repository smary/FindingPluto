//
//  AnimalsListViewModel.swift
//  FindingPluto
//
//  Created by Mariana on 04.11.2022.
//

import Foundation
import RxSwift


final class AnimalsListViewModel {
    
    let title = "Pets List"
    
    private let animalsService: AnimalsServiceProtocol
    
    init (animalsService: AnimalsServiceProtocol = PetFinderService(requestsManager: RequestsManager())) {
        self.animalsService = animalsService
    }
    
    func fetchAnimalViewModels() -> Observable<[AnimalViewModel]> {
        animalsService.fetchAnimals()
            .map { animalsList in
                animalsList.map { animal in
                    AnimalViewModel(animal: animal)
                }                
            }
    }
}
