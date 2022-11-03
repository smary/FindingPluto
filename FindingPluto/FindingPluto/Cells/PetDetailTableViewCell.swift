//
//  PetDetailTableViewCell.swift
//  FindingPluto
//
//  Created by Mariana on 01.11.2022.
//

import UIKit

class PetDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var petName: UILabel!
    @IBOutlet weak var petGender: UILabel!
    @IBOutlet weak var petSize: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
