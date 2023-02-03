//
//  ImageLoader.swift
//  PhotographyLessons
//
//  Created by Aysel Heydarova on 03.02.23.
//

import SwiftUI

struct ImageLoader: View {
    @ObservedObject private var imageLoader = ImageLoaderCache()
    let url: URL

    var body: some View {
        switch imageLoader.image {
        case .success(let image):
            self.imageLoader.cacheImage(image, for: self.url)
            return AnyView(
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 60)
            )

        case .failure, nil:
            return AnyView(
                ZStack {
                    Rectangle()
                        .frame(maxWidth: 100, maxHeight: 60)
                        .cornerRadius(5)
                        .foregroundColor(Color.gray)
                    ProgressView()
                }
            )
        }
    }

    init(url: URL) {
        self.url = url
        self.imageLoader.loadImage(url: url)
    }
}

class ImageLoaderCache: ObservableObject {
    private var cache = NSCache<NSURL, UIImage>()
    private let queue = DispatchQueue(label: "image-loader")

    @Published private(set) var image: Result<UIImage, Error>?

    func loadImage(url: URL) {
        queue.async {
            if let image = self.cache.object(forKey: url as NSURL) {
                DispatchQueue.main.async {
                    self.image = .success(image)
                }
                return
            }

            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    DispatchQueue.main.async {
                        self.image = .failure(error)
                    }
                    return
                }

                guard let data = data, let image = UIImage(data: data) else {
                    DispatchQueue.main.async {
                        self.image = .failure(NSError(domain: "ImageLoaderCache", code: 0, userInfo: nil))
                    }
                    return
                }

                self.cache.setObject(image, forKey: url as NSURL)
                DispatchQueue.main.async {
                    self.image = .success(image)
                }
            }.resume()
        }
    }

    func cacheImage(_ image: UIImage, for url: URL) {
        queue.async {
            self.cache.setObject(image, forKey: url as NSURL)
        }
    }
}
