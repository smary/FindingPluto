//
//  TraitDetailCell.swift
//  FindingPluto
//
//  Created by Mariana on 05.11.2022.
//

import UIKit

class TraitDetailCell: UITableViewCell {

    static let identifier = "TraitCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupViews() {
        self.selectionStyle = .none
        self.detailTextLabel?.font = UIFont(name: "Helvetica", size: 14)
        
    }
    
    func configure(viewModel: TraitDetailCellViewModel) {
        textLabel?.text = viewModel.title
        detailTextLabel?.text = viewModel.trait
    }
}
