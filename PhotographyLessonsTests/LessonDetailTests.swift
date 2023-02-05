//
//  LessonDetailTests.swift
//  PhotographyLessonsTests
//
//  Created by Aysel Heydarova on 05.02.23.
//

import XCTest
@testable import PhotographyLessons

final class LessonDetailsViewModelTests: XCTestCase {
    var sut: LessonDetailsViewModel!
    var lessons: [Lesson]!
    var currentLessonIndex: Int!
    let mockURLSession = MockURLSession()

    override func setUp() {
        super.setUp()
        lessons = [
            Lesson(id: 1, name: "Lesson 1", thumbnail: "", description: "test description", videoURL: "https://example.com/lesson1.mp4"),
            Lesson(id: 2, name: "Lesson 2", thumbnail: "", description: "test description 2", videoURL: "https://example.com/lesson2.mp4"),
        ]
        currentLessonIndex = 0
        sut = LessonDetailsViewModel(lessons: lessons, currentLessonIndex: currentLessonIndex, urlSession: mockURLSession)
    }

    override func tearDown() {
        sut = nil
        lessons = nil
        currentLessonIndex = nil

        super.tearDown()
    }

    func testNextButtonTapped() {
        // Given
        XCTAssertEqual(sut.currentLessonIndex, 0)

        // When
        sut.nextButtonTapped()

        // Then
        XCTAssertEqual(sut.currentLessonIndex, 1)
    }

    func testCheckIfFileExists() {
        // Given
        let fileManager = FileManager.default
        let fileName = sut.lesson.videoURL.split(separator: "/").last!
        let filePath = sut.getFilePath(for: String(fileName))
        let isFileExists = fileManager.fileExists(atPath: filePath)

        // When
        sut.checkIfFileExists()

        // Then
        if isFileExists {
            XCTAssertEqual(sut.downloadState, .downloaded)
        } else {
            XCTAssertEqual(sut.downloadState, .initial)
        }
    }

    func testDownloadVideo() {
        // Given
        XCTAssertEqual(sut.downloadState, .initial)

        // When
        sut.downloadVideo()

        // Then

        XCTAssertEqual(sut.downloadState, .downloading)
        XCTAssertEqual(mockURLSession.downloadTaskCount, 1)
        XCTAssertEqual(
            mockURLSession.downloadTaskURL.first,
             URL(string: "https://example.com/lesson1.mp4")
        )
    }

    func testCancelDownload() {
        // Given
        XCTAssertEqual(sut.downloadState, .initial)

        // When
        sut.downloadVideo()
        sut.cancelDownload()

        // Then
        XCTAssertEqual(sut.downloadState, .canceled)
    }

    func testTrackDownload() {
        sut.downloadVideo()
        XCTAssertNotNil(sut.observation)
    }
}

