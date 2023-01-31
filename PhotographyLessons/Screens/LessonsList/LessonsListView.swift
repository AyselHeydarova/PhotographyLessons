//
//  LessonsListView.swift
//  PhotographyLessons
//
//  Created by Aysel Heydarova on 30.01.23.
//

import SwiftUI

struct LessonsListView: View {
    @State private var lessons = [Lesson]()
    @State private var isLoading = false

    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    ProgressView()
                } else {
                    List(lessons) { lesson in
                        NavigationLink(destination: LessonDetailsViewControllerWrapper(lesson: lesson)) {
                            LessonRow(lesson: lesson)
                        }
                    }
                }
            }
            .navigationBarTitle("Lessons")
            .onAppear(perform: loadData)
        }
    }

    private func loadData() {
        guard !isLoading else { return }

        isLoading = true
        let url = URL(string: "https://iphonephotographyschool.com/test-api/lessons")!

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            let lessonsResponse = try! JSONDecoder().decode(LessonsResponse.self, from: data)

            self.lessons = lessonsResponse.lessons
            self.isLoading = false
        }
        .resume()
    }
}


struct LessonsListView_Previews: PreviewProvider {
    static var previews: some View {
        LessonsListView()
    }
}
