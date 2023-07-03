//
//  OAuth2Service.swift
//  YaImageFeed
//
//  Created by Сергей Денисенко on 06.05.2023.
//

import Foundation

final class OAuth2Service {

    static let shared = OAuth2Service()

    private let urlSession = URLSession.shared
    private let tokenStorage = OAuth2TokenStorage()
    private (set) var authToken: String? {
        get {
            return tokenStorage.token
        }
        set {
            tokenStorage.token = newValue
        }
    }
    private var task: URLSessionTask?
    private var lastCode: String?

    private init() {}

    func fetchOAuthToken(
        _ code: String,
        completion: @escaping (Result<String, Error>) -> Void ){
            assert(Thread.isMainThread)

            if task != nil {
                if lastCode != code {
                    task?.cancel()
                } else {
                    return
                }
            } else {
                if lastCode == code {
                    return
                }
            }

            lastCode = code

            let request = authTokenRequest(code: code)
            let task = urlSession.objectTask(for: request) { (result: Result<OAuthTokenResponseBody, Error>) in
                switch result {
                case .success(let body):
                    let authToken = body.accessToken
                    self.authToken = authToken
                    completion(.success(authToken))
                case .failure(let error):
                    completion(.failure(error))
                }
            }


//            let task = object(for: request) { [weak self] result in
//                guard let self = self else { return }
//                switch result {
//                case .success(let body):
//                    let authToken = body.accessToken
//                    self.authToken = authToken
//                    completion(.success(authToken))
//                case .failure(let error):
//                    completion(.failure(error))
//                }
//            }
            self.task = task
            task.resume()
        }

//    private func object(
//        for request: URLRequest,
//        completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void
//    ) -> URLSessionTask {
//        let decoder = JSONDecoder()
//        return urlSession.data(for: request) { (result: Result<Data, Error>) in
//            let response = result.flatMap { data -> Result<OAuthTokenResponseBody, Error> in
//                Result { try decoder.decode(OAuthTokenResponseBody.self, from: data) }
//            }
//            completion(response)
//        }
//    }

    private func authTokenRequest(code: String) -> URLRequest {
        URLRequest.makeHTTPRequest(
            path: "/oauth/token"
            + "?client_id=\(AccessKey)"
            + "&&client_secret=\(SecretKey)"
            + "&&redirect_uri=\(RedirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            httpMethod: "POST",
            baseURL: URL(string: "https://unsplash.com")!
        )
    }
}
