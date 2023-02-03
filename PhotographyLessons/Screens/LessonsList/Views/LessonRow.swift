//
//  LessonRow.swift
//  PhotographyLessons
//
//  Created by Aysel Heydarova on 31.01.23.
//

import SwiftUI

struct LessonRow: View {
    let lesson: Lesson

    var body: some View {
        HStack {
            ImageLoader(url: URL(string: lesson.thumbnail)!)
                .cornerRadius(5)

            Text(lesson.name)
        }
    }
}
