//
//  AnimalsListViewController.swift
//  FindingPluto
//
//  Created by Mariana on 04.11.2022.
//

import UIKit
import RxSwift
import RxCocoa
import Foundation
import RxKingfisher

class ListViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel: AnimalsListViewModel!
    let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        viewModel = AnimalsListViewModel.init()
        navigationItem.title = viewModel.title
        
        viewModel.fetchAnimalViewModels()
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: PetListCell.identifier, cellType: PetListCell.self)) {
                index, itemViewModel, cell in
                cell.configure(viewModel: itemViewModel)
            }
            .disposed(by: bag)
        
        tableView.rx.modelSelected(AnimalViewModel.self)
            .subscribe(onNext: { [weak self] itemViewModel in
                if let detailViewController = self?.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
                    detailViewController.viewModel = DetailViewModel(animalViewModel: itemViewModel)
                    self?.navigationController?.pushViewController(detailViewController, animated: true)
                }
            })
            .disposed(by: bag)
    }
}
