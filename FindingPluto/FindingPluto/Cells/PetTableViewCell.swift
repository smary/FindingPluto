//
//  PetTableViewCell.swift
//  FindingPluto
//
//  Created by Mariana on 31.10.2022.
//

import UIKit

class PetTableViewCell: UITableViewCell {

    @IBOutlet weak var petName: UILabel!
    @IBOutlet weak var petStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
