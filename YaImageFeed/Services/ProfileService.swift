//
//  ProfileService.swift
//  YaImageFeed
//
//  Created by Сергей Денисенко on 17.06.2023.
//

import Foundation

final class ProfileService {
    
    static let shared = ProfileService()
    private(set) var profile: Profile?
    private let oauth2Service = OAuth2Service.shared
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?

    private init() {}
    
    func fetchProfile(
        completion: @escaping (Result<Profile, Error>) -> Void ) {
            
            assert(Thread.isMainThread)
            
            let request = profileRequest()

            let task = urlSession.objectTask(for: request) { (result: Result<ProfileResult, Error>) in
                switch result {
                case .success(let body):
                    let profile = Profile(username: body.userName,
                                          name: (body.firstName ?? "") + " " + (body.lastName ?? ""),
                                          bio: body.bio ?? "")
                    self.profile = profile
                    completion(.success(profile))
                case .failure(let error):
                    completion(.failure(error))
                }
            }

            self.task = task
            task.resume()
        }
    
    private func profileRequest() -> URLRequest {
        var request = URLRequest.makeHTTPRequest(
            path: "/me",
            httpMethod: "GET")
        guard let token = oauth2Service.authToken else {return request}
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
