//
//  LessonDetailsViewModel.swift
//  PhotographyLessons
//
//  Created by Aysel Heydarova on 02.02.23.
//

import Foundation

enum DownloadState {
    case initial
    case downloading
    case canceled
    case downloaded
}

class LessonDetailsViewModel {
    var downloadState: DownloadState = .initial
    var downloadProgress: Float = 0.0
    var resumeData: Data?
    var downloadTask: URLSessionDownloadTask?
    var observation: NSKeyValueObservation?

    func checkIfFileExists(with name: String) -> Bool {
        let fileManager = FileManager.default
        let filePath = getFilePath(for: name)
        return fileManager.fileExists(atPath: filePath)
    }

    func getFilePath(for name: String) -> String {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = documentsDirectory.appendingPathComponent(name).path

        return filePath
    }

    func handleDownloadStatus(downloadState: DownloadState) {
        self.downloadState = downloadState
        switch downloadState {
        case .initial:
            break
        case .downloading:
            break
        case .canceled:
            break
        case .downloaded:
            break
        }
    }
    
}
