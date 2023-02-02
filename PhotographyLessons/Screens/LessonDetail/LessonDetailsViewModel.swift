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
