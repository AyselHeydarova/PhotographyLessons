//
//  MockURLSession.swift
//  PhotographyLessonsTests
//
//  Created by Aysel Heydarova on 05.02.23.
//

import Foundation
@testable import PhotographyLessons

private class DummyURLSessionDataTask: URLSessionDataTask {
    override func resume() {
    }
}

private class DummyURLSessionDownloadTask: URLSessionDownloadTask {
    override func resume() {
    }
}

class MockURLSession: URLSessionProtocol {
    var downloadTaskCount = 0
    var downloadTaskURL: [URL] = []

    var dataTaskCallCount = 0
    var dataTaskArgsRequest: [URLRequest] = []

    var isResumeCalled = false

    func dataTask(with request: URLRequest, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        dataTaskCallCount += 1
        dataTaskArgsRequest.append(request)

        return DummyURLSessionDataTask()
    }

    func downloadTask(with url: URL, completionHandler: @escaping @Sendable (URL?, URLResponse?, Error?) -> Void) -> URLSessionDownloadTask {
        downloadTaskCount += 1
        downloadTaskURL.append(url)

        return DummyURLSessionDownloadTask()
    }

    func downloadTask(withResumeData resumeData: Data) -> URLSessionDownloadTask {
        isResumeCalled = true

        return DummyURLSessionDownloadTask()
    }

}
