//
//  LessonListViewModel.swift
//  PhotographyLessons
//
//  Created by Aysel Heydarova on 31.01.23.
//

import SwiftUI

class LessonListViewModel: ObservableObject {
    @Published var lessons = [Lesson]()

    func fetchLessons() {
        let endpoint = PhotographyLessonsAPI.fetchLessons

        NetworkManager
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

            UserDefaults.standard.set(lessonsData, forKey: "LessonList")
        } catch {
            print("Error encoding object: \(error)")
        }
    }

    func getLessonList() -> [Lesson] {
        if let data = UserDefaults.standard.data(forKey: "LessonList") {
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
