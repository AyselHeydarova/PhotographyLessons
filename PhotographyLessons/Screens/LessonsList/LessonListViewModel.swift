//
//  LessonListViewModel.swift
//  PhotographyLessons
//
//  Created by Aysel Heydarova on 31.01.23.
//

import SwiftUI

protocol UserDefaultsProtocol {
    func set(_ value: Any?, forKey defaultName: String)
    func data(forKey defaultName: String) -> Data?
}

extension UserDefaults: UserDefaultsProtocol {}

class LessonListViewModel: ObservableObject {
    @Published var lessons = [Lesson]()

    private var networkManager: NetworkManager
    private var userDefaults: UserDefaultsProtocol = UserDefaults.standard

    init(
        networkManager: NetworkManager = NetworkManager(),
        userDefaults: UserDefaultsProtocol = UserDefaults.standard
    ) {
        self.networkManager = networkManager
        self.userDefaults = userDefaults
    }

    func fetchLessons() {
        let endpoint = PhotographyLessonsAPI.fetchLessons

        networkManager
            .request(endpoint: endpoint) { [weak self] (result: Result<LessonsResponse, Error>) in
                guard let self = self else { return }

                switch result {
                case .success(let data):
                    self.lessons = data.lessons
                    self.saveLessonListInCache(data.lessons)

                case .failure(_):
                    self.lessons = self.getLessonList()
                }
            }
    }

    func saveLessonListInCache(_ lessons: [Lesson]) {
        do {
            let encoder = JSONEncoder()
            let lessonsData = try encoder.encode(lessons)

            userDefaults.set(lessonsData, forKey: "LessonList")
        } catch {
            print("Error encoding object: \(error)")
        }
    }

    func getLessonList() -> [Lesson] {
        if let data = userDefaults.data(forKey: "LessonList") {
            do {
                let decoder = JSONDecoder()
                let lessons = try decoder.decode([Lesson] .self, from: data)
                return lessons

            } catch {
                print("Error decoding object: \(error)")
            }
        }
        return []
    }
}
