//
//  LessonDetailsViewControllerWrapper.swift
//  PhotographyLessons
//
//  Created by Aysel Heydarova on 31.01.23.
//

import SwiftUI

struct LessonDetailsViewControllerWrapper: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIViewController

    private let lessons: [Lesson]
    private let currentIndex: Int

    init(lessons: [Lesson], currentIndex: Int) {
        self.lessons = lessons
        self.currentIndex = currentIndex
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<LessonDetailsViewControllerWrapper>) -> UIViewController {
        let viewModel = LessonDetailsViewModel(lessons: lessons, currentLessonIndex: currentIndex)
        let viewController = LessonDetailsViewController(
            viewModel: viewModel
        )
        return viewController
    }
    

    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<LessonDetailsViewControllerWrapper>) {}
}
