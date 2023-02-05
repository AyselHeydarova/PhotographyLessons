//
//  LessonListViewModelTests.swift
//  LessonListViewModelTests
//
//  Created by Aysel Heydarova on 30.01.23.
//

import XCTest
@testable import PhotographyLessons

class LessonListViewModelTests: XCTestCase {

    var sut: LessonListViewModel!
    let mockSession = MockURLSession()
    let fakeUserDefaults = FakeUserDefaults()

    override func setUp() {
        let networkManager = NetworkManager(session: mockSession)
        sut = LessonListViewModel(networkManager: networkManager, userDefaults: fakeUserDefaults)
    }

    override func tearDown() {
        UserDefaults.standard.removeObject(forKey: "LessonList")
    }

    func testFetchLessonsSuccess() {
        sut.fetchLessons()

        XCTAssertEqual(mockSession.dataTaskCallCount, 1)
        XCTAssertEqual(
            mockSession.dataTaskArgsRequest.first,
            URLRequest(url: URL(string: "https://iphonephotographyschool.com/test-api/lessons?")!)
        )
    }

    func testSaveLessonListInCache() {
        let lessonsData = stubbedData("Lessons")
        let lessons = try! JSONDecoder().decode(LessonsResponse.self, from: lessonsData)

        sut.saveLessonListInCache(lessons.lessons)

        XCTAssertNotNil(fakeUserDefaults.data(forKey: "LessonList"))
    }

    func testGetLessonList() {
        let lessonsData = stubbedData("Lessons")
        let lessons = try! JSONDecoder().decode(LessonsResponse.self, from: lessonsData)
        sut.saveLessonListInCache(lessons.lessons)

        XCTAssertEqual(sut.getLessonList().count, 11)
    }

    private func stubbedData(_ fileName: String) -> Data {
        let bundle = Bundle(for: type(of: self))
        let path = bundle.path(forResource: fileName, ofType: "json")!

        return try! Data(contentsOf: URL(fileURLWithPath: path))
    }
}

