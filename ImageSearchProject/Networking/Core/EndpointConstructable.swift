//
//  EndpointConstructable.swift
//  ImageSearchProject
//
//  Created by Eric Rado on 7/9/21.
//

import Foundation

protocol EndpointConstructable {
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var httpTask: HTTPTask { get }
}

extension EndpointConstructable {
    var baseURL: String {
        return "https://api.imgur.com/3"
    }
}
