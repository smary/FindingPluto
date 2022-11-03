//
//  AnimalsTableViewController.swift
//  FindingPluto
//
//  Created by Mariana on 01.11.2022.
//

import UIKit
import RxSwift
import RxCocoa
import Foundation

class AnimalsTableViewController: UITableViewController {
    
    let networkService = NetworkService()
    
    let animalsFetcher: AnimalsFetcher = PetFinderService(requestsManager: RequestsManager())
    let bag = DisposeBag()
    
    private var animalsListViewModel: AnimalsListViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Pets List"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.tableView.delegate = nil
        self.tableView.dataSource = nil

        fetchAnimals()
//        fetchTokenAndAnimals()
    }
    
    func fetchTokenAndAnimals() {
        networkService.getAccessToken()
            .flatMap { token -> Observable<AnimalsResponse> in
                let getAnimalsURL = URL(string: PetFinderAPIConstants.baseURL + PetFinderAPIConstants.paths["animals"]!)!
                return self.networkService.fetchData(url: getAnimalsURL, token: token)
            }
            .map { $0.animals ?? []}
            .bind(to: tableView.rx.items(cellIdentifier: "petCell", cellType: PetTableViewCell.self)) {
                index, petItem, cell in
                cell.petName.text = petItem.name
            }
            .disposed(by: bag)
    }
    
    func fetchAnimals() {
        animalsFetcher.fetchAnimals()
            .bind(to: tableView.rx.items(cellIdentifier: "petCell", cellType: PetTableViewCell.self)) {
                index, petItem, cell in
                cell.petName.text = petItem.name
            }
//            .subscribe(onNext: { animals in
//                self.animalsListViewModel = AnimalsListViewModel.init(animals)
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                }
//            })
            .disposed(by: bag)
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if let animalsListViewModel = animalsListViewModel {
//            return animalsListViewModel.itemsCount
//        }
//        return 0
//    }
//
//    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if let cell = tableView.dequeueReusableCell(withIdentifier: "petCell", for: indexPath) as? PetTableViewCell {
//            
//            if let animalViewModel = animalsListViewModel?.animalAt(index: indexPath.row) {
//                animalViewModel.name
//                    .bind(to: cell.petName.rx.text)
//                    .disposed(by: bag)
//                animalViewModel.status
//                    .bind(to: cell.petStatus.rx.text)
//                    .disposed(by: bag)
//            }
//            return cell
//        }
//        return UITableViewCell()
//    }
//    
//
//    /*
//    // Override to support conditional editing of the table view.
//    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        // Return false if you do not want the specified item to be editable.
//        return true
//    }
//    */
//
//    /*
//    // Override to support editing the table view.
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            // Delete the row from the data source
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }    
//    }
//    */
//
//    /*
//    // Override to support rearranging the table view.
//    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
//
//    }
//    */
//
//    /*
//    // Override to support conditional rearranging of the table view.
//    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
//        // Return false if you do not want the item to be re-orderable.
//        return true
//    }
//    */
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */

}
