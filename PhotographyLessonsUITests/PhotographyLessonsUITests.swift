//
//  PhotographyLessonsUITests.swift
//  PhotographyLessonsUITests
//
//  Created by Aysel Heydarova on 30.01.23.
//

import XCTest
@testable import PhotographyLessons

final class LessonDetailsViewControllerUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
        app.collectionViews.buttons["How To Preserve Your Memories With iPhone Live Photos"].tap()
    }

    func testProgressView() {
        let progressView = app.progressIndicators.element
        XCTAssertFalse(progressView.exists)

        app.navigationBars.buttons["Download"].tap()

        XCTAssertTrue(progressView.exists)
    }

    func testDownloadButtonExists() {
        XCTAssert(app.navigationBars.buttons["Download"].exists)
    }

    func testTitleLabelExists() {
        XCTAssert(app.staticTexts["How To Preserve Your Memories With iPhone Live Photos"].exists)
    }

    func testNextButtonExists() {
        XCTAssert(app.buttons["Next Lesson"].exists)
    }

    func testNextButtonTapped() {
        app.buttons["Next Lesson"].tap()
        XCTAssert(app.buttons["Next Lesson"].exists)
    }

    func testCancelDownload() {
        app.navigationBars.buttons["Download"].tap()
        XCTAssert(app.navigationBars.buttons["Cancel"].exists)
    }

    func testResumeDownload() {
        app.navigationBars.buttons["Download"].tap()
        app.navigationBars.buttons["Cancel"].tap()

        XCTAssert(app.navigationBars.buttons["Resume"].exists)
    }
}


