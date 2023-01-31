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
            AsyncImage(
                url: URL(string: lesson.thumbnail),
                content: { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 100, maxHeight: 100)
                        .cornerRadius(10)
                },
                placeholder: {
                    ProgressView()
                }
            )

            Text(lesson.name)
        }
    }
}
