//
//  LessonDetailsViewController.swift
//  PhotographyLessons
//
//  Created by Aysel Heydarova on 30.01.23.
//

import UIKit
import AVKit
import SwiftUI

class LessonDetailsViewController: UIViewController {
    private let activityIndicator = UIActivityIndicatorView(style: .large)

    private lazy var videoPreviewLayer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var videoPlayer: AVPlayerViewController = {
        let player = AVPlayerViewController()
        player.view.translatesAutoresizingMaskIntoConstraints = false
        player.view.backgroundColor = .systemBackground
        return player
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
    }()

    private lazy var progressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "0 ldksjlkf"
        label.tintColor = .blue
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private lazy var nextButton: UIButton = {
        let button = UIButton(type: .infoLight)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Next Lesson", for: .normal)
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        button.semanticContentAttribute = .forceRightToLeft
        return button
    }()

    private var urlSession: URLSession!
    var downloadTask: URLSessionDownloadTask?

    private var lessons: [Lesson]
    private var lesson: Lesson
    private var currentLessonIndex: Int {
        didSet {
            lesson = lessons[currentLessonIndex]
        }
    }

    init(lessons: [Lesson], currentLessonIndex: Int) {
        self.lessons = lessons
        self.currentLessonIndex = currentLessonIndex
        self.lesson = lessons[currentLessonIndex]
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        configure()
//        downloadVideo()
      }

    @objc func nextButtonTapped() {
        if currentLessonIndex + 1 < lessons.count {
            currentLessonIndex += 1
            configure()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        videoPlayer.player?.pause()
    }

    private func addSubviews() {
        [videoPreviewLayer, titleLabel, descriptionLabel, nextButton, progressLabel]
            .forEach(view.addSubview)
        activityIndicator.startAnimating()
        videoPreviewLayer.addSubview(activityIndicator)
        self.videoPlayer.view.frame = self.videoPreviewLayer.frame
        self.addChild(self.videoPlayer)
        self.view.addSubview(self.videoPlayer.view)

        videoPlayer.player?.addObserver(self, forKeyPath: "status", options: [.old, .new], context: nil)
        addConstraints()
    }

    private func configure() {
        urlSession = URLSession(configuration: .default,
                                 delegate: self,
                                 delegateQueue: nil)

        playVideo(with: URL(string: lesson.videoURL)!)
        startDownload(url: URL(string: lesson.videoURL)!)
        titleLabel.text = lesson.name
        descriptionLabel.text = lesson.description
    }

    @objc func downloadButtonTapped() {
        downloadVideo()
    }

    private func startDownload(url: URL) {
        print("LOG: startDownload")

        let downloadTask = urlSession.downloadTask(with: url)
        downloadTask.resume()
        self.downloadTask = downloadTask
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status", let player = object as? AVPlayer, player.status == .readyToPlay {
            switch  player.status {
            case .readyToPlay:
                activityIndicator.stopAnimating()
                player.play()
                print("LOG: observe player status readyToPlay")
            case .failed:
                print("LOG: observe player status failed")
            case .unknown:
                print("LOG: observe player status unknown")
            @unknown default:
                fatalError()
            }
        }
    }


    private func addConstraints() {
        NSLayoutConstraint.activate([
            videoPreviewLayer.heightAnchor.constraint(equalToConstant: 250),
            videoPreviewLayer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant:  -20),
            videoPreviewLayer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            videoPreviewLayer.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            videoPlayer.view.heightAnchor.constraint(equalToConstant: 250),
            videoPlayer.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant:  -20),
            videoPlayer.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            videoPlayer.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            titleLabel.topAnchor.constraint(equalTo: videoPreviewLayer.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            nextButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            progressLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            progressLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
        ])
    }

    func downloadVideo() {
//        let videoURL = URL(string: "https://embed-ssl.wistia.com/deliveries/acc8428860020162b3cac4ed6534727b5ef3af42/cidu4le3c8.mp4")!
        let videoURL = URL(string: lesson.videoURL)!

        let downloadTask = URLSession.shared.downloadTask(with: videoURL) {
            urlOrNil, responseOrNil, errorOrNil in
            // check for and handle errors:
            // * errorOrNil should be nil
            // * responseOrNil should be an HTTPURLResponse with statusCode in 200..<299

            guard let fileURL = urlOrNil else { return }
            do {
                let documentsURL = try
                FileManager.default.url(for: .documentDirectory,
                                        in: .userDomainMask,
                                        appropriateFor: nil,
                                        create: false)
                let savedURL = documentsURL.appendingPathComponent(
                    fileURL
                        .lastPathComponent
                        .replacingOccurrences(of: ".tmp", with: ".mp4")
                )

                try FileManager.default.moveItem(at: fileURL, to: savedURL)
                print ("file savedURL: \(savedURL)")
                DispatchQueue.main.async {
                    self.playVideo(with: savedURL)
//                    let player = AVPlayer(url: savedURL)
//                    self.videoPlayer.player = player
//                    self.videoPlayer.view.frame = self.videoPreviewLayer.frame
//                    self.addChild(self.videoPlayer)
//                    self.view.addSubview(self.videoPlayer.view)
                }

            } catch {
                print ("file error: \(error)")
            }
        }
        downloadTask.resume()
    }

    func playVideo(with url: URL) {
        let player = AVPlayer(url: url)
        self.videoPlayer.player = player
    }

}

extension LessonDetailsViewController: URLSessionDelegate {
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64,
                    totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64) {
        print("LOG: downloadTask \(downloadTask)")

        if downloadTask == self.downloadTask {
            let calculatedProgress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
            DispatchQueue.main.async {
                print("LOG: calculatedProgress \(calculatedProgress)")
                self.progressLabel.text = String(describing: calculatedProgress)
//                self.percentFormatter.string(
//                    from:
//                        NSNumber(value: calculatedProgress)
//                )
            }
        }
    }

    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL) {
        // check for and handle errors:
        // * downloadTask.response should be an HTTPURLResponse with statusCode in 200..<299

        do {
            let documentsURL = try
                FileManager.default.url(for: .documentDirectory,
                                        in: .userDomainMask,
                                        appropriateFor: nil,
                                        create: false)
            let savedURL = documentsURL.appendingPathComponent(
                location.lastPathComponent.replacingOccurrences(of: ".tmp", with: ".mp4"))
            try FileManager.default.moveItem(at: location, to: savedURL)
            print("LOG: savedURL \(savedURL)")

            DispatchQueue.main.async {
                self.playVideo(with: savedURL)
//                    let player = AVPlayer(url: savedURL)
//                    self.videoPlayer.player = player
//                    self.videoPlayer.view.frame = self.videoPreviewLayer.frame
//                    self.addChild(self.videoPlayer)
//                    self.view.addSubview(self.videoPlayer.view)
            }
        } catch {
            print("LOG: filesystem error")
            // handle filesystem error
        }
    }
}
