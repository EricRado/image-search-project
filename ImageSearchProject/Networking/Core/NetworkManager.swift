//
//  NetworkManager.swift
//  ImageSearchProject
//
//  Created by Eric Rado on 7/9/21.
//

import Foundation

enum NetworkError: String, Error {
    case badURLFormat = "URL is not formatted properly."
    case unknown
}

final class NetworkManager {
    private let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func request<T: Decodable>(_ endpoint: EndpointConstructable, completion: @escaping (Result<T, Error>) -> Void) {
        guard let request = buildURLRequest(with: endpoint) else {
            completion(.failure(NetworkError.badURLFormat))
            return
        }
        
        session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let model = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(model))
                } catch let error {
                    completion(.failure(error))
                }
            } else {
                completion(.failure(NetworkError.unknown))
            }
        }.resume()
        
    }
    
    func requestImage(_ urlString: String, completion: @escaping (Result<Data, Error>) -> ()) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.badURLFormat))
            return
        }
        
        let cache = URLCache.shared
        let request = URLRequest(url: url)
        
        if let cachedURLResponse = cache.cachedResponse(for: request) {
            completion(.success(cachedURLResponse.data))
        } else {
            session.downloadTask(with: url) { url, response, error in
                if let error = error {
                    completion(.failure(error))
                } else if let validURL = url,
                          let response = response,
                          let data = try? Data(contentsOf: validURL) {
                    let cachedURLResponse = CachedURLResponse(response: response, data: data)
                    cache.storeCachedResponse(cachedURLResponse, for: request)
                    completion(.success(data))
                } else {
                    completion(.failure(NetworkError.unknown))
                }
            }.resume()
        }
    }
    
    private func buildURLRequest(with endpoint: EndpointConstructable) -> URLRequest? {
        guard let url = buildURL(with: endpoint) else {
            return nil
        }
        
        var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        urlRequest.httpMethod = endpoint.httpMethod.rawValue
        urlRequest.setValue("Client-ID b067d5cb828ec5a", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("keep-alive", forHTTPHeaderField: "Connection")
        return urlRequest
    }
    
    private func buildURL(with endpoint: EndpointConstructable) -> URL? {
        guard var urlComponents = URLComponents(string: endpoint.path) else {
            return nil
        }
        
        var urlQueryItems: [URLQueryItem] = []
        if case let .requestParameters(parameters) = endpoint.httpTask {
            for (key, value) in parameters {
                urlQueryItems.append(URLQueryItem(name: key, value: value))
            }
        }
        
        urlComponents.queryItems = urlQueryItems
        
        return urlComponents.url
    }
}
