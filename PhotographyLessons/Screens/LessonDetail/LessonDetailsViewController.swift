//
//  LessonDetailsViewController.swift
//  PhotographyLessons
//
//  Created by Aysel Heydarova on 30.01.23.
//

import UIKit
import AVKit
import Combine
import SwiftUI

class LessonDetailsViewController: UIViewController {
    private let activityIndicator = UIActivityIndicatorView(style: .large)

    private lazy var videoPreviewLayer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var progressView: UIProgressView = {
        let view = UIProgressView()
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
    
    var downloadTask: URLSessionDownloadTask?
    
    private var observation: NSKeyValueObservation?
    private var lessons: [Lesson]
    private var lesson: Lesson
    private var currentLessonIndex: Int {
        didSet {
            lesson = lessons[currentLessonIndex]
        }
    }
    
    deinit {
        observation?.invalidate()
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "icloud.and.arrow.down"), for: .normal)
        button.setTitle("Download", for: .normal)
        button.sizeToFit()
        button.addTarget(self, action:  #selector(downloadButtonTapped), for: .touchUpInside)
        self.parent?.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        configure()
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
        [videoPreviewLayer, titleLabel, descriptionLabel, nextButton, progressView]
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
        playVideo(with: URL(string: lesson.videoURL)!)
        titleLabel.text = lesson.name
        descriptionLabel.text = lesson.description
        progressView.isHidden = true
    }
    
    @objc func downloadButtonTapped() {
        downloadVideo()
    }
    
    @objc func cancelDownload() {
        downloadTask?.cancel()
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
            
            progressView.topAnchor.constraint(equalTo: videoPlayer.view.bottomAnchor, constant: 16),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            titleLabel.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            nextButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    func downloadVideo() {
        let videoURL = URL(string: lesson.videoURL)!
        
        self.parent?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDownload))
        
        downloadTask = URLSession.shared.downloadTask(with: videoURL) {
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
                DispatchQueue.main.async {
                    self.playVideo(with: savedURL)
                }
                
            } catch {
                print ("file error: \(error)")
            }
        }
        observation = downloadTask?.progress.observe(\.fractionCompleted) { progress, _ in
            DispatchQueue.main.async {
                self.progressView.isHidden = false
                self.progressView.progress = Float(progress.fractionCompleted)

                if self.progressView.progress == 1 {
                    self.progressView.isHidden = true
                    self.parent?.navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .done)
                }
            }
            print("downloadVideo progress: ", progress.fractionCompleted)
        }
        downloadTask?.resume()
    }
    
    func playVideo(with url: URL) {
        let player = AVPlayer(url: url)
        self.videoPlayer.player = player
    }
}
