//
//  LessonsResponse.swift
//  PhotographyLessons
//
//  Created by Aysel Heydarova on 31.01.23.
//

import Foundation

struct LessonsResponse: Decodable {
    let lessons: [Lesson]
}

struct Lesson: Decodable, Identifiable {
    let id: Int
    let name: String
    let thumbnail: String
    let description: String
    let videoURL: String

    private enum CodingKeys: String, CodingKey {
        case id, name, thumbnail, description
        case videoURL = "video_url"
    }
}
