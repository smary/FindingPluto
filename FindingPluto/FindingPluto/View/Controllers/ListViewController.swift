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
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var viewModel: AnimalsListViewModel = AnimalsListViewModel.init()
    let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        bindViewModel()
        setupCellSelection()
    }
    
    func bindViewModel() {
        navigationItem.title = viewModel.title
        activityIndicator.startAnimating()

        let animalViewModels = viewModel.fetchAnimalViewModels().share()
        animalViewModels
            .catchAndReturn([])
            .observe(on: MainScheduler.instance)
            .do(onCompleted: { [weak self] in
                self?.activityIndicator.stopAnimating()
            }
            )
            .bind(to: tableView.rx.items(cellIdentifier: PetListCell.identifier, cellType: PetListCell.self)) {
                index, itemViewModel, cell in
                cell.configure(viewModel: itemViewModel)
            }
            .disposed(by: bag)

        animalViewModels
            .observe(on: MainScheduler.instance)
            .subscribe(onError: { [weak self] error in
                if let err = error as? NetworkError {
                    self?.presentAlert(with: err.errorDescription ?? "")
                    self?.activityIndicator.stopAnimating()
                }
                print("")
            })
            .disposed(by: bag)
    }
    
    func setupCellSelection() {
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
