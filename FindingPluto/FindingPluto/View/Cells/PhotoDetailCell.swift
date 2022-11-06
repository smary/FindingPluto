//
//  DetailPhotoTableViewCell.swift
//  FindingPluto
//
//  Created by Mariana on 04.11.2022.
//

import UIKit

class PhotoDetailCell: UITableViewCell {
    
    static let identifier = "PhotoCell"
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupViews() {
        self.selectionStyle = .none
        self.contentView.addSubview(photoImageView)
    }
    
    private func setupLayout() {
        super.layoutSubviews()
        NSLayoutConstraint.activate(
            [
                photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                photoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
                photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
                photoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            ]
        )
    }
    
    func configure(viewModel: PhotoDetailCellViewModel) {
        if let imageURL: URL = URL(string: viewModel.photoURLString) {
            photoImageView.kf.setImage(with: imageURL, placeholder: UIImage(named: "placeholder"))
        } else {
            photoImageView.image = UIImage(named: viewModel.placeholder)
        }
    }
}
