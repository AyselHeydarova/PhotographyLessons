//
//  LessonDetailsViewControllerWrapper.swift
//  PhotographyLessons
//
//  Created by Aysel Heydarova on 31.01.23.
//

import SwiftUI

struct LessonDetailsViewControllerWrapper: UIViewControllerRepresentable {
    private let lesson: Lesson

    init(lesson: Lesson) {
        self.lesson = lesson
    }

    typealias UIViewControllerType = UIViewController

    func makeUIViewController(context: UIViewControllerRepresentableContext<LessonDetailsViewControllerWrapper>) -> UIViewController {
        return LessonDetailsViewController(lesson: lesson)
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<LessonDetailsViewControllerWrapper>) {}
}
