//
//  UIViewController+Extensions.swift
//  FindingPluto
//
//  Created by Mariana on 05.11.2022.
//

import Foundation
import UIKit

extension UIViewController {
    
    func presentAlert(with message: String) {
       let alertVC = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
       alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
       present(alertVC, animated: true, completion: nil)
    }
}
