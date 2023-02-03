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
        let url = URL(string: "https://iphonephotographyschool.com/test-api/lessons")!

        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self else { return }

            if error != nil {
                self.lessons = self.getLessonList()
            } else if let data = data {
                let lessonsResponse = try! JSONDecoder().decode(LessonsResponse.self, from: data)
                DispatchQueue.main.async {
                    self.lessons = lessonsResponse.lessons
                }
                self.saveLessonListInCache(lessonsResponse.lessons)
            }
        }
        .resume()
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
