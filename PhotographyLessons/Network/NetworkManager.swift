//
//  NetworkManager.swift
//  PhotographyLessons
//
//  Created by Aysel Heydarova on 05.02.23.
//

import Foundation

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask

    func downloadTask(with url: URL, completionHandler: @escaping @Sendable (URL?, URLResponse?, Error?) -> Void) -> URLSessionDownloadTask

    func downloadTask(withResumeData resumeData: Data) -> URLSessionDownloadTask
}

extension URLSession: URLSessionProtocol { }

final class NetworkManager {

    var session: URLSessionProtocol

    init(session: URLSessionProtocol = URLSession(configuration: .default)) {
        self.session = session
    }

    private func buildURL(endpoint: API) -> URLComponents {
        var components = URLComponents()
        components.scheme = endpoint.scheme.rawValue
        components.host = endpoint.baseURL
        components.path = endpoint.path
        components.queryItems = endpoint.parameters
        return components
    }

    func request<T: Decodable>(endpoint: API,
                                     completion: @escaping (Result<T, Error>)
                                     -> Void) {
        let components = buildURL(endpoint: endpoint)
        guard let url = components.url else {
            print("URL creation error")
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.method.rawValue

        let dataTask = session.dataTask(with: urlRequest) {
            data, response, error in
            if let error = error {
                completion(.failure(error))
                print("Unknown error", error)
                return
            }
            guard response != nil, let data = data else {
                return
            }
            if let responseObject = try? JSONDecoder().decode(T.self,
                                                              from: data) {
                DispatchQueue.main.async {
                    completion(.success(responseObject))
                }
            } else {
                let error = NSError(
                    domain: "",
                    code: 200,
                    userInfo: [
                        NSLocalizedDescriptionKey: "Failed"
                    ]
                )
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        dataTask.resume()
    }
}

