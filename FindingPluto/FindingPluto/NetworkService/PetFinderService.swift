//
//  PetFinderService.swift
//  FindingPluto
//
//  Created by Mariana on 03.11.2022.
//

import Foundation
import RxSwift

protocol AnimalsServiceProtocol {
    func fetchAnimals() -> Observable<[Animal]>
}

protocol TokenServiceProtocol {
    func fetchAccessToken() -> Observable<String>
}


class PetFinderService {
    
    private let requestsManager: RequestsManagerProtocol
    
    init(requestsManager: RequestsManagerProtocol) {
        self.requestsManager = requestsManager
    }
}

extension PetFinderService: AnimalsServiceProtocol {
    
    func fetchAnimals() -> Observable<[Animal]> {
        
        let animalsObservable: Observable <[Animal]> = fetchAccessToken()
            .flatMap { token -> Observable<AnimalsResponse> in
                return self.requestsManager.fetchData(request: AnimalsRequest.getAnimalsList, token: token)
            }
            .map { $0.animals ?? []}
        return animalsObservable
    }
}

extension PetFinderService: TokenServiceProtocol {
    
    func fetchAccessToken() -> Observable<String> {
        let accessTokenObservale: Observable<AccessToken>  = self.requestsManager.fetchData(request: AuthTokenRequest.auth, token: "")
        let token = accessTokenObservale
            .map {$0.bearerAccessToken }
        return token
    }
}


