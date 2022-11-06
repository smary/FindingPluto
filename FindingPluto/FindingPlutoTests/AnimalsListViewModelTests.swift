//
//  AnimalsListViewModelTests.swift
//  FindingPlutoTests
//
//  Created by Mariana on 06.11.2022.
//

import Foundation
import RxSwift
import XCTest
@testable import FindingPluto

class AnimalsTableViewViewModelTests: XCTestCase {
    
    func testNumberOfAnimalViewModels() {
        let disposeBag = DisposeBag()
        let petFinderService = MockPetFinderService(requestsManager: RequestsManager(), tokenManager: AccessTokenManager(userDefaults: .standard))
        petFinderService.getAnimalsResult = .success(payload: [Animal.dummy()])
        
        let viewModel = AnimalsListViewModel.init(clientService: petFinderService)
        

        let expectNbOfAnimalModelsToBe1 = expectation(description: "animalsViewModels has a count of 1")
        viewModel.fetchAnimalViewModels()
            .subscribe(onNext: { animalViewModels in
                let c = animalViewModels.count
                XCTAssertEqual(c, 1)
                expectNbOfAnimalModelsToBe1.fulfill()
            })
            .disposed(by: disposeBag)
        wait(for: [expectNbOfAnimalModelsToBe1], timeout: 0.1)
    }
}

enum Result<R, NetworkError> {
    case success(payload: R)
    case failure(NetworkError?)
}

private final class MockPetFinderService: PetFinderService {
    var getAnimalsResult: Result<[Animal], NetworkError>?
 
    override func fetchAnimals() -> Observable<[Animal]> {
        return Observable.create { [weak self] observer in
            switch self?.getAnimalsResult {
            case .success(let animals)?:
                observer.onNext(animals)
            case .failure(let error)?:
                observer.onError(error!)
            case .none:
                observer.onError(NetworkError.invalidResponse)
            }
            return Disposables.create()
        }
    }
}
