//
//  LessonsListView.swift
//  PhotographyLessons
//
//  Created by Aysel Heydarova on 30.01.23.
//

import SwiftUI

struct LessonsListView: View {
    @StateObject var viewModel = LessonListViewModel()

    var body: some View {
        NavigationView {
            VStack {
                List(viewModel.lessons.indices, id: \.self) { index in
                    NavigationLink(
                        destination: LessonDetailsViewControllerWrapper(
                            lessons: viewModel.lessons,
                            currentIndex: index
                        )
                    ) {
                        LessonRow(lesson: viewModel.lessons[index])
                    }
                }
                .navigationBarTitle("Lessons")
                .onAppear(perform: viewModel.fetchLessons)
            }
        }
    }
}

struct LessonsListView_Previews: PreviewProvider {
    static var previews: some View {
        LessonsListView()
    }
}

