//
//  PetFinderService.swift
//  FindingPluto
//
//  Created by Mariana on 03.11.2022.
//

import Foundation
import RxSwift

protocol AnimalsFetcher {
    func fetchAnimals() -> Observable<[Animal]>
}

class PetFinderService {
    
    private let requestsManager: RequestsManagerProtocol
    
    init(requestsManager: RequestsManagerProtocol) {
        self.requestsManager = requestsManager
    }
}

extension PetFinderService: AnimalsFetcher {
    
    func fetchAnimals() -> Observable<[Animal]> {
        
        let animalsObservable: Observable <[Animal]> = getAccessToken()
            .flatMap { token -> Observable<AnimalsResponse> in
                return self.requestsManager.fetchData(request: AnimalsRequest.getAnimalsList, token: token)
            }
            .map { $0.animals ?? []}
        return animalsObservable
    }
    
    
    func getAccessToken() -> Observable<String> {
        let accessTokenObservale: Observable<AccessToken>  = self.requestsManager.fetchData(request: AuthTokenRequest.auth, token: "")
        let token = accessTokenObservale
            .map {$0.bearerAccessToken }
        return token
    }
}
