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
    func fetchAccessToken() -> Observable<AccessToken>
}


class PetFinderService : AnimalsServiceProtocol, TokenServiceProtocol {
    
    private let requestsManager: RequestsManagerProtocol
    private let tokenManager: AccessTokenManagerProtocol
    
    init(requestsManager: RequestsManagerProtocol, tokenManager: AccessTokenManagerProtocol) {
        self.requestsManager = requestsManager
        self.tokenManager = tokenManager
    }
    
    func fetchAnimals() -> Observable<[Animal]> {
        if tokenManager.isAccessTokenValid() == true {
            return Observable<String>.just(tokenManager.fetchAccessToken())
                .flatMap{ [weak self] token -> Observable<AnimalsResponse> in
                    return self?.requestsManager.fetchData(request: AnimalsRequest.getAnimalsList, token: token) ?? Observable.empty()
                }
                .map{ $0.animals ?? [] }
        } else {
            return fetchAccessToken()
            //TODO: save token
                .map{ $0.bearerAccessToken }
                .flatMap{ token -> Observable<AnimalsResponse> in
                    return self.requestsManager.fetchData(request: AnimalsRequest.getAnimalsList, token: token)
                }
                .map{ $0.animals ?? [] }
        }
    }
    
    func fetchAccessToken() -> Observable<AccessToken> {
        self.requestsManager.fetchData(request: AuthTokenRequest.auth, token: "")
    }
}


