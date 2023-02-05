//
//  API.swift
//  PhotographyLessons
//
//  Created by Aysel Heydarova on 05.02.23.
//

import Foundation

protocol API {
    var scheme: HTTPScheme { get }
    var baseURL: String { get }
    var path: String { get }
    var parameters: [URLQueryItem] { get }
    var method: HTTPMethod { get }
}

enum PhotographyLessonsAPI: API {
    case fetchLessons

    var scheme: HTTPScheme {
        switch self {
        case .fetchLessons:
            return .https
        }
    }

    var baseURL: String {
        switch self {
        case .fetchLessons:
            return "iphonephotographyschool.com"
        }
    }

    var path: String {
        switch self {
        case .fetchLessons:
            return "/test-api/lessons"
        }
    }

    var parameters: [URLQueryItem] {
        switch self {
        case .fetchLessons:
            return []
        }
    }

    var method: HTTPMethod {
        switch self {
        case .fetchLessons:
            return .get
        }
    }
}
