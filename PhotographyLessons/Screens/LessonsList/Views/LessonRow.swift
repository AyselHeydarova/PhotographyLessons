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
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 60)
                        .cornerRadius(5)
                },
                placeholder: {
                    ZStack {
                        Rectangle()
                            .frame(maxWidth: 100, maxHeight: 60)
                            .cornerRadius(5)
                            .foregroundColor(Color.gray)
                        ProgressView()
                    }
                }
            )

            Text(lesson.name)
        }
    }
}
