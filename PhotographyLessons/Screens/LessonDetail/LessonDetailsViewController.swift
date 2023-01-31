//
//  LessonDetailsViewController.swift
//  PhotographyLessons
//
//  Created by Aysel Heydarova on 30.01.23.
//

import UIKit
import AVKit

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
        button.semanticContentAttribute = .forceRightToLeft
        return button
    }()

    private var lesson: Lesson

    init(lesson: Lesson) {
        self.lesson = lesson
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        downloadVideo()
      }

    private func setup() {
        [videoPreviewLayer, titleLabel, descriptionLabel, nextButton]
            .forEach(view.addSubview)
        activityIndicator.startAnimating()
        videoPreviewLayer.addSubview(activityIndicator)


        let videoURL = URL(string: "https://embed-ssl.wistia.com/deliveries/acc8428860020162b3cac4ed6534727b5ef3af42/cidu4le3c8.mp4")!

        let player = AVPlayer(url: videoURL)
        self.videoPlayer.player = player
        self.videoPlayer.view.frame = self.videoPreviewLayer.frame

        self.addChild(self.videoPlayer)
        self.view.addSubview(self.videoPlayer.view)

        videoPlayer.player?.addObserver(self, forKeyPath: "status", options: [.old, .new], context: nil)
        titleLabel.text = lesson.name
        descriptionLabel.text = lesson.description
        addConstraints()

        let downloadButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.down"), style: .plain, target: self, action: #selector(downloadButtonTapped))
        downloadButton.title = "Download"
        navigationController?.navigationItem.rightBarButtonItem = downloadButton
    }

    @objc func downloadButtonTapped() {
        print("LOG: download tapped")

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
            videoPreviewLayer.topAnchor.constraint(equalTo: view.topAnchor),
            videoPreviewLayer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            videoPreviewLayer.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            videoPlayer.view.heightAnchor.constraint(equalToConstant: 250),
            videoPlayer.view.topAnchor.constraint(equalTo: view.topAnchor),
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
        ])
    }

    func downloadVideo() {
        let videoURL = URL(string: "https://embed-ssl.wistia.com/deliveries/acc8428860020162b3cac4ed6534727b5ef3af42/cidu4le3c8.mp4")!

//        let player = AVPlayer(url: videoURL)
//        self.videoPlayer.player = player
//        self.videoPlayer.view.frame = self.videoPreviewLayer.frame
//        self.addChild(self.videoPlayer)
//        self.view.addSubview(self.videoPlayer.view)

//                let task = URLSession.shared.downloadTask(with: videoURL) { localUrl, response, error in
//                    DispatchQueue.main.async {
//                        if let localUrl = localUrl {
//                            self.activityIndicator.stopAnimating()
//                            let player = AVPlayer(url: localUrl)
//                            self.videoPlayer.player = player
//                            self.videoPlayer.view.frame = self.videoPreviewLayer.frame
//                            self.addChild(self.videoPlayer)
//                            self.view.addSubview(self.videoPlayer.view)
//                        }
//                    }
//                }
//                task.resume()
    }

}
