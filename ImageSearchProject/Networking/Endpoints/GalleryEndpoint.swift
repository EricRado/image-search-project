//
//  GalleryEndpoint.swift
//  ImageSearchProject
//
//  Created by Eric Rado on 7/9/21.
//

import Foundation

enum GalleryEndpoint: EndpointConstructable {
    case search(input: String)
    
    var path: String {
        switch self {
        case .search:
            return self.baseURL + "/gallery/search/"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .search:
            return .get
        }
    }
    
    var httpTask: HTTPTask {
        switch self {
        case .search(let input):
            return .requestParameters(["q": input])
        
        }
    }
}
