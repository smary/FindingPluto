//
//  AnimalsListViewModel.swift
//  FindingPluto
//
//  Created by Mariana on 04.11.2022.
//

import Foundation
import RxSwift
import RxRelay

final class AnimalsListViewModel {
    
    let title = "Pets List"
    
    private let clientService: PetFinderService
    private var animalViewModels: Observable<[AnimalViewModel]>
    
    init (clientService: PetFinderService = PetFinderService(requestsManager: RequestsManager(),
                                                             tokenManager: AccessTokenManager(userDefaults: .standard))) {
        self.clientService = clientService
        self.animalViewModels = Observable.empty()
    }
    
    func fetchAnimalViewModels() -> Observable<[AnimalViewModel]> {
        clientService.fetchAnimals()
            .map { animalsList in
                animalsList.map { animal in
                    AnimalViewModel(animal: animal)
                }
            }
    }
}
