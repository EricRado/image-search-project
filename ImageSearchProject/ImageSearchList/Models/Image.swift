//
//  Image.swift
//  ImageSearchProject
//
//  Created by Eric Rado on 7/9/21.
//

import Foundation

struct Image {
    let id: String
    let title: String
    let description: String
    let type: String
    let imageLink: String
    
    init(dto: ImageDTO) {
        self.id = dto.id ?? ""
        self.title = dto.title ?? ""
        self.description = dto.description ?? ""
        self.type = dto.images?.first?.type ?? ""
        self.imageLink = dto.images?.first?.link ?? ""
    }
}
