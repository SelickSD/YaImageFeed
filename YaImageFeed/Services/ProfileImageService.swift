//
//  ProfileImageService.swift
//  YaImageFeed
//
//  Created by Сергей Денисенко on 18.06.2023.
//

import UIKit

final class ProfileImageService {

    static let shared = ProfileImageService()
    static let DidChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    private let urlSession = URLSession.shared
    private let profileService = ProfileService.shared
    private let oauth2Service = OAuth2Service.shared
    private var task: URLSessionTask?
    private (set) var profileImageURL: URL?


    private init() {}

    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<URL, Error>) -> Void) {

        assert(Thread.isMainThread)

        let request = profileImageRequest(username: username)

        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            switch result {
            case .success(let body):
                completion(.success(body.profileImageLink.resizedImageURL))
                self?.profileImageURL = body.profileImageLink.resizedImageURL

                NotificationCenter.default
                    .post(
                        name: ProfileImageService.DidChangeNotification,
                        object: self,
                        userInfo: ["URL": self?.profileImageURL ?? ""])
            case .failure(let error):
                completion(.failure(error))
            }
        }

        self.task = task
        task.resume()
    }

    private func profileImageRequest(username: String) -> URLRequest {
        var request = URLRequest.makeHTTPRequest(
            path: "/users/\(username)",
            httpMethod: "GET")
        guard let token = oauth2Service.authToken else {return request}
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
