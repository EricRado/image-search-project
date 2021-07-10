//
//  HTTPTask.swift
//  ImageSearchProject
//
//  Created by Eric Rado on 7/9/21.
//

import Foundation

typealias Parameters = [String: String]

enum HTTPTask {
    case request
    case requestParameters(Parameters)
}
