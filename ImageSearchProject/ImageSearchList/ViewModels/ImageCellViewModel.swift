//
//  ImageCellViewModel.swift
//  ImageSearchProject
//
//  Created by Eric Rado on 7/9/21.
//

import Foundation

struct ImageCellViewModel: Hashable {
    let id: String
    let title: String
    let urlString: String
    let description: String
    
    init(with image: Image) {
        self.id = image.id
        self.title = image.title
        self.urlString = image.imageLink
        self.description = image.description
    }
    
    func hash(into hasher: inout Hasher){
        hasher.combine(id)
    }
    
    static func == (lhs: ImageCellViewModel, rhs: ImageCellViewModel) -> Bool {
        return lhs.id == rhs.id
    }
}
