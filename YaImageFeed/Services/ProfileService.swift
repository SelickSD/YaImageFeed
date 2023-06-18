//
//  ProfileService.swift
//  YaImageFeed
//
//  Created by Сергей Денисенко on 17.06.2023.
//

import Foundation

final class ProfileService {
    
    static let shared = ProfileService()
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private(set) var profile: Profile?
    
    private init() {}
    
    func fetchProfile(
        token: String = OAuth2TokenStorage().token ?? "",
        completion: @escaping (Result<Profile, Error>) -> Void ) {
            
            assert(Thread.isMainThread)
            
            let request = profileRequest(token: token)
            let task = object(for: request) { [weak self] result in
                guard self != nil else { return }
                switch result {
                case .success(let body):
                    let profile = Profile(username: body.userName,
                                          name: (body.firstName ?? "") + " " + (body.lastName ?? ""),
                                          bio: body.bio ?? "")
                    self?.profile = profile
                    completion(.success(profile))
                case .failure(let error):
                    completion(.failure(error))
                    print(error)
                }
            }
            self.task = task
            task.resume()
        }
    
    private func object(
        for request: URLRequest,
        completion: @escaping (Result<ProfileResult, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = JSONDecoder()

        return urlSession.data(for: request) { (result: Result<Data, Error>) in
            let response = result.flatMap { data -> Result<ProfileResult, Error> in
                return Result {
                    try decoder.decode(ProfileResult.self, from: data)
                }
            }
            completion(response)
        }
    }
    
    private func profileRequest(token: String) -> URLRequest {
        var request = URLRequest.makeHTTPRequest(
            path: "/me",
            httpMethod: "GET")
//        guard let token = OAuth2TokenStorage().token else {return request}
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
