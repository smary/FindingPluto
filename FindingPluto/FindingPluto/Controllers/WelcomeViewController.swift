//
//  WelcomeViewController.swift
//  FindingPluto
//
//  Created by Mariana on 04.11.2022.
//

import UIKit

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .yellow
    }
    
    @IBAction func showPetsList(_ sender: Any) {
        if let listViewController = self.storyboard?.instantiateViewController(withIdentifier: "listViewController") as? AnimalsListViewController {
            self.navigationController?.pushViewController(listViewController, animated: true)
        }
    }
}
