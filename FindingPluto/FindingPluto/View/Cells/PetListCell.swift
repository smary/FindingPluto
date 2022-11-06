//
//  PetTableViewCell.swift
//  FindingPluto
//
//  Created by Mariana on 31.10.2022.
//

import UIKit

class PetListCell: UITableViewCell {
    
    static let identifier = "PetListCell"

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var thumbImageView: UIImageView!
    
    
    func configure(viewModel: AnimalViewModel) {
        nameLabel.text = viewModel.name
        statusLabel.text = viewModel.status
        genderLabel.text = viewModel.gender
        if let imageURL: URL = URL(string: viewModel.thumbnailURLString) {
            thumbImageView.kf.setImage(with: imageURL, placeholder: UIImage(named: "placeholder"))
        } else {
            thumbImageView.image = UIImage(named: "placeholder")
        }
    }
}
