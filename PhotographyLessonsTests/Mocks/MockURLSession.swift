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

class MockURLSession: URLSessionProtocol {
    var dataTaskCallCount = 0
    var dataTaskArgsRequest: [URLRequest] = []

    func dataTask(with request: URLRequest, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        dataTaskCallCount += 1
        dataTaskArgsRequest.append(request)

        return DummyURLSessionDataTask()
    }
}
