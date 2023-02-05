//
//  Enums.swift
//  PhotographyLessons
//
//  Created by Aysel Heydarova on 05.02.23.
//

import Foundation

enum HTTPMethod: String {
    case delete = "DELETE"
    case get = "GET"
    case patch = "PATCH"
    case post = "POST"
    case put = "PUT"
}

enum HTTPScheme: String {
    case http
    case https
}
