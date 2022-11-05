//
//  DetailViewModel.swift
//  FindingPluto
//
//  Created by Mariana on 04.11.2022.
//

import Foundation

import RxSwift
import RxCocoa
import RxDataSources


class DetailViewModel {

    private let animalViewModel: AnimalViewModel!
    private var _sectionModels: BehaviorSubject<[SectionsModel]> = BehaviorSubject(value: [])
    
    var sectionModels: SharedSequence<DriverSharingStrategy, [SectionsModel]> {
        return _sectionModels.asDriver(onErrorJustReturn: [])
    }
    var title: String {
        return animalViewModel.name
    }
    var photoCellHeight: CGFloat {
        return 300
    }
    var traitCellHeight: CGFloat {
        return 65
    }
    
    init(animalViewModel: AnimalViewModel) {
        self.animalViewModel = animalViewModel
        configureSectionModel(with: animalViewModel)
    }
    
    var photoIndexPath: IndexPath {
        return IndexPath(row: 0, section: 0)
    }
    
    private func configureSectionModel(with animal: AnimalViewModel ) {
        let sections: [SectionsModel] = [
            .photoSection(title: "", items: [
                .photo(PhotoDetailCellViewModel(photoURLString: animal.thumbnailURLString, placeholder: "placeholder"))
            ]),
            .traitsSection(title: "Traits", items: [
                .trait(TraitDetailCellViewModel(title: "Gender:", trait: animal.gender)),
                .trait(TraitDetailCellViewModel(title: "Size:", trait: animal.size)),
                .trait(TraitDetailCellViewModel(title: "Status:", trait: animal.status)),
                .trait(TraitDetailCellViewModel(title: "Breeds:", trait: animal.breed)),
            ])
        ]
        _sectionModels.onNext(sections)
    }
}

enum DetailItem {
    case photo (PhotoDetailCellViewModel)
    case trait (TraitDetailCellViewModel)
}

enum SectionsModel {
    case photoSection(title: String, items: [DetailItem])
    case traitsSection(title: String, items: [DetailItem])
    
    var title: String {
        switch self {
        case .photoSection(title: let title, items: _):
            return title
        case .traitsSection(title: let title, items: _):
            return title
        }
    }
}

extension SectionsModel: SectionModelType {
    
    var items: [DetailItem] {
        switch  self {
        case .photoSection(title: _, items: let items):
            return items.map { $0 }
        case .traitsSection(title: _, items: let items):
            return items.map { $0 }
        }
    }
    
    init(original: SectionsModel, items: [DetailItem]) {
           switch original {
           case let .photoSection(title: title, items: _):
               self = .photoSection(title: title, items: items)
           case let .traitsSection(title: title, items: _):
               self = .traitsSection(title: title, items: items)
           }
       }
}
