//
//  ImageDTO.swift
//  ImageSearchProject
//
//  Created by Eric Rado on 7/9/21.
//

import Foundation

struct ImageResponseDTO: Decodable {
    let items: [ImageDTO]?
    let success: Bool?
    let status: Int?
    
    private enum CodingKeys: String, CodingKey {
        case items = "data"
        case success
        case status
    }
}

struct ImageDTO: Decodable {
    let id: String?
    let title: String?
    let description: String?
    let images: [ImageDetailDTO]?
}

struct ImageDetailDTO: Decodable {
    let type: String?
    let link: String?
}
