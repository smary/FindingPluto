//
//  DetailViewController.swift
//  FindingPluto
//
//  Created by Mariana on 04.11.2022.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay
import RxDataSources
import RxKingfisher

class DetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private let disposeBag = DisposeBag()
    
    var viewModel: DetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        configureUI()
        bindToModels()
    }
    
    private func configureUI() {
        self.title = viewModel.title
        self.navigationController?.navigationBar.prefersLargeTitles = true

        tableView.register(TraitDetailCell.self, forCellReuseIdentifier: TraitDetailCell.identifier)
        tableView.register(PhotoDetailCell.self, forCellReuseIdentifier: PhotoDetailCell.identifier)
        tableView.bounces = false
    }
    
    private func bindToModels() {
        let dataSource = DetailViewController.dataSource()
        viewModel.sectionModels
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView
            .rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
}

extension DetailViewController {
    static func dataSource() -> RxTableViewSectionedReloadDataSource<SectionsModel> {
        return RxTableViewSectionedReloadDataSource<SectionsModel>(
            
            configureCell: { dataSource, tableView, indexPath, _ in
                switch dataSource[indexPath] {
                case .photo(let photoModel):
                    let cell = PhotoDetailCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: PhotoDetailCell.identifier)
                    cell.configure(viewModel: photoModel)
                    return cell
            
                case .trait(let traitModel):
                    let cell = TraitDetailCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: TraitDetailCell.identifier)
                    cell.configure(viewModel: traitModel)
                    return cell
                }
            },
            titleForHeaderInSection: { dataSource, index in
                let section = dataSource[index]
                return section.title
            })
    }
}

extension DetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == viewModel.photoIndexPath{
            return viewModel.photoCellHeight
        }
        return viewModel.traitCellHeight
    }
}

