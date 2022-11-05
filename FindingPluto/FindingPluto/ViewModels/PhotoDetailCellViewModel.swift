//
//  PhotoCellViewModel.swift
//  FindingPluto
//
//  Created by Mariana on 05.11.2022.
//

import Foundation

final class PhotoDetailCellViewModel {
    let photoURLString: String
    let placeholder: String
    
    init(photoURLString: String, placeholder: String) {
        self.photoURLString = photoURLString
        self.placeholder = placeholder
    }
}
