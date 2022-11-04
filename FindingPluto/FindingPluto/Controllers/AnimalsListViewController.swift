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

class AnimalsListViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    private var viewModel: AnimalsListViewModel!
    let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Pets List"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        
        viewModel = AnimalsListViewModel.init()
        navigationItem.title = viewModel.title
        viewModel.fetchAnimalViewModels()
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: "petListCell", cellType: PetTableViewCell.self)) {
                index, itemViewModel, cell in
                cell.nameLabel.text = itemViewModel.name
                cell.statusLabel.text = itemViewModel.breed
                if let imageURL: URL = itemViewModel.thumbnailURL {
                    cell.thumbImageView.kf.setImage(with: imageURL, placeholder: UIImage(named: "placeholder"))
                } else {
                    cell.thumbImageView.image = UIImage(named: "placeholder")
                }
            }
            .disposed(by: bag)
    }
}
