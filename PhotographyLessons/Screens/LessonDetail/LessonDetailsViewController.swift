//
//  LessonDetailsViewController.swift
//  PhotographyLessons
//
//  Created by Aysel Heydarova on 30.01.23.
//

import UIKit
import AVKit
import Combine

class LessonDetailsViewController: UIViewController {

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

    private lazy var downloadButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "icloud.and.arrow.down"), for: .normal)
        button.setTitle("Download", for: .normal)
        button.sizeToFit()
        button.addTarget(self, action:  #selector(downloadButtonTapped), for: .touchUpInside)

        return button
    }()
    
    private var subscriptions = Set<AnyCancellable>()
    private var viewModel: LessonDetailsViewModel

    init(viewModel: LessonDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.checkIfFileExists()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        videoPlayer.player?.pause()
    }

    private func setup() {
        addSubviews()
        addConstraints()
        handleLessonChange()
        handleDownloadState()
        handleDownloadProgress()
    }

    private func handleDownloadState() {
        viewModel.$downloadState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] downloadState in
                guard let self = self else { return }

                switch downloadState {
                case .initial:
                    self.parent?.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.downloadButton)
                case .downloading:
                    self.setRightBarItem(title: "Cancel", action:  #selector(self.cancelDownload))
                case .canceled:
                    self.setRightBarItem(title: "Resume", action: #selector(self.resumeDownload))
                case .downloaded:
                    self.setRightBarItem(title: "Downloaded", action: nil)
                }
            }
            .store(in: &subscriptions)
    }

    private func handleLessonChange() {
        viewModel.$lesson
            .receive(on: DispatchQueue.main)
            .sink { [weak self] lesson in
                guard let self = self else { return }
                self.titleLabel.text = lesson.name
                self.descriptionLabel.text = lesson.description
                self.viewModel.checkIfFileExists()

                guard let url = self.viewModel.urlForVideo else { return }
                self.playVideo(with: url)

            }.store(in: &subscriptions)
    }

    private func handleDownloadProgress() {
        viewModel.$isProgressViewHidden
            .receive(on: DispatchQueue.main)
            .sink { isHidden in
                self.progressView.isHidden = isHidden
            }.store(in: &subscriptions)

        viewModel.$downloadProgress
            .receive(on: DispatchQueue.main)
            .sink { [weak self] progress in
            self?.progressView.progress = progress
        }.store(in: &subscriptions)
    }

    private func setRightBarItem(title: String, action: Selector?) {
        self.parent?
            .navigationItem
            .rightBarButtonItem = UIBarButtonItem(title: title, style: .plain, target: self, action: action)
    }

    private func playVideo(with url: URL) {
        let player = AVPlayer(url: url)
        self.videoPlayer.player = player
    }

    @objc func downloadButtonTapped() {
        viewModel.downloadVideo()
    }

    @objc func cancelDownload() {
        viewModel.cancelDownload()
    }

    @objc func resumeDownload() {
        viewModel.resumeDownload()
    }

    @objc func nextButtonTapped() {
        viewModel.nextButtonTapped()
    }

    private func addSubviews() {
        [titleLabel, descriptionLabel, nextButton, progressView]
            .forEach(view.addSubview)

        self.addChild(self.videoPlayer)
        self.view.addSubview(self.videoPlayer.view)
        
        videoPlayer.player?.addObserver(self, forKeyPath: "status", options: [.old, .new], context: nil)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
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
}
