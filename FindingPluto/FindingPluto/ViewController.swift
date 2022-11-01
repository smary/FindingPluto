//
//  ViewController.swift
//  FindingPluto
//
//  Created by Mariana on 30.10.2022.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let disposeBag = DisposeBag()
    private let networkservice = NetworkService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Pets list"
        
        networkservice.getAnimals()
            .map { animalsResult -> [Animal] in
                return animalsResult.animals ?? []
            }
            .bind(to: tableView.rx.items(cellIdentifier: "petCell", cellType: PetTableViewCell.self)) {
                row, animalItem, cell in
                cell.petName.text = animalItem.name
            }
            .disposed(by: disposeBag)
    }
}



