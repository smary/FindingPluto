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
        bindViewModel()
    }
    
    private func configureUI() {
        tableView.register(TraitDetailCell.self, forCellReuseIdentifier: TraitDetailCell.identifier)
        tableView.register(PhotoDetailCell.self, forCellReuseIdentifier: PhotoDetailCell.identifier)
    }
    
    private func bindViewModel() {
        self.title = viewModel.title
        let dataSource = DetailViewController.dataSource()
        viewModel.sectionModels
            .drive(tableView.rx.items(dataSource: dataSource))
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

