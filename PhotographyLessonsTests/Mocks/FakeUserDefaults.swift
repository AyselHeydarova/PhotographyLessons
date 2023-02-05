//
//  FakeUserDefaults.swift
//  PhotographyLessonsTests
//
//  Created by Aysel Heydarova on 06.02.23.
//

import Foundation
@testable import PhotographyLessons

class FakeUserDefaults: UserDefaultsProtocol {
    var data: [String: Any] = [:]

    func set(_ value: Any?, forKey defaultName: String) {
        data[defaultName] = value
    }

    func data(forKey defaultName: String) -> Data? {
        data[defaultName] as? Data
    }
}
