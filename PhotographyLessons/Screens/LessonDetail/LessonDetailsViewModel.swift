//
//  LessonDetailsViewModel.swift
//  PhotographyLessons
//
//  Created by Aysel Heydarova on 02.02.23.
//

import Foundation
import Combine

enum DownloadState {
    case initial
    case downloading
    case canceled
    case downloaded
}

class LessonDetailsViewModel {
    @Published var isProgressViewHidden: Bool = true
    @Published var downloadProgress: Float = 0.0
    @Published var lesson: Lesson
    @Published var downloadState: DownloadState = .initial

    private var urlSession: URLSessionProtocol
    private var subscriptions = Set<AnyCancellable>()
    private var resumeData: Data?
    private (set) var downloadTask: URLSessionDownloadTask?
    private (set) var observation: NSKeyValueObservation?
    private var lessons: [Lesson]
    private (set) var currentLessonIndex: Int {
        didSet {
            lesson = lessons[currentLessonIndex]
        }
    }

    var urlForVideo: URL?

    init(lessons: [Lesson], currentLessonIndex: Int, urlSession: URLSessionProtocol = URLSession.shared) {
        self.urlSession = urlSession
        self.lessons = lessons
        self.lesson = lessons[currentLessonIndex]
        self.currentLessonIndex = currentLessonIndex

        $downloadState.sink { [weak self] state in
            guard let self = self else { return }

            switch state {
            case .initial:
                self.isProgressViewHidden = true
            case .downloading:
                self.isProgressViewHidden = false
                self.trackDownload()
            case .canceled:
                self.isProgressViewHidden = false
            case .downloaded:
                self.isProgressViewHidden = true
            }
        }.store(in: &subscriptions)
    }

    func checkIfFileExists() {
        let url = URL(string: lesson.videoURL)
        let fileName = url?.lastPathComponent
        guard let fileName = fileName else { return }

        let fileManager = FileManager.default
        let filePath = getFilePath(for: fileName)
        let isFileExists = fileManager.fileExists(atPath: filePath)

        downloadState = isFileExists ? .downloaded : .initial
        urlForVideo = isFileExists ? URL(filePath: filePath) : url

        return
    }

    func getFilePath(for name: String) -> String {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = documentsDirectory.appendingPathComponent(name).path

        return filePath
    }

    func nextButtonTapped() {
        if currentLessonIndex + 1 < lessons.count {
            currentLessonIndex += 1
        }
    }

    func downloadVideo() {
        let url =  URL(string: lesson.videoURL)
        guard let url = url else { return }

        downloadState = .downloading
        downloadTask = urlSession.downloadTask(with: url) {
            urlOrNil, responseOrNil, errorOrNil in

            guard let fileURL = urlOrNil else { return }
            do {
                let documentsURL = try
                FileManager.default.url(for: .documentDirectory,
                                        in: .userDomainMask,
                                        appropriateFor: nil,
                                        create: false)
                let savedURL = documentsURL.appendingPathComponent(
                    url.lastPathComponent
                )

                try FileManager.default.moveItem(at: fileURL, to: savedURL)
                self.urlForVideo = savedURL

            } catch {
                print ("file error: \(error)")
            }
        }
        trackDownload()
        downloadTask?.resume()
    }

    func cancelDownload() {
        downloadTask?.cancel  { resumeDataOrNil in
            guard let resumeData = resumeDataOrNil else {
                    self.downloadState = .initial
              return
            }
            self.resumeData = resumeData
        }
        downloadState = .canceled
    }

    func resumeDownload() {
        guard let resumeData = resumeData else {
            DispatchQueue.main.async {
                self.downloadState = .initial
            }
            return
        }

        let downloadTask = urlSession.downloadTask(withResumeData: resumeData)
        downloadTask.resume()
        self.downloadTask = downloadTask
        downloadState = .downloading
    }

    func trackDownload() {
        observation = downloadTask?.progress.observe(\.fractionCompleted) { progress, _ in
            self.downloadProgress = Float(progress.fractionCompleted)
            if self.downloadProgress == 1 {
                self.downloadState = .downloaded
            }
        }
    }
}
