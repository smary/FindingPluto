////
////  AnimalsViewModel.swift
////  FindingPluto
////
////  Created by Mariana on 01.11.2022.
////
//
//import Foundation
//import RxSwift
//
//
//struct AnimalsListViewModel {
//    let animals: [AnimalViewModel]
//}
//
//extension AnimalsListViewModel {
//    
//    init (_ animals: [Animal]) {
//        self.animals = animals.compactMap(AnimalViewModel.init)
//    }
//    
//    func animalAt(index: Int) -> AnimalViewModel {
//        return self.animals[index]
//    }
//    
//    var itemsCount: Int {        
//        return animals.count
//    }
//}
//
//
//
//
//struct AnimalViewModel {
//    let animal: Animal
//}
//
//extension AnimalViewModel {
//    var name: Observable<String> {
//        return Observable<String>.just(animal.name ?? "")
//    }
//    
//    var gender: Observable<String> {
//        return Observable<String>.just(animal.gender ?? "")
//    }
//    
//    var size: Observable<String> {
//        return Observable<String>.just(animal.size ?? "")
//    }
//    
//    var status: Observable<String> {
//        return Observable<String>.just(animal.status ?? "")
//    }
//    
//    var distance: Observable<Int> {
//        return Observable<Int>.just(animal.distance ?? 0) // TODO: - implement logic for diatnce not available
//    }
//}
