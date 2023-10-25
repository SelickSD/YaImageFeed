//
//  URLRequest + Extentions.swift
//  YaImageFeed
//
//  Created by Сергей Денисенко on 05.06.2023.
//

import Foundation

extension URLRequest {

    static func makeHTTPRequest(
        path: String,
        httpMethod: String,
        baseURL: URL = DefaultBaseURL,
        needToken: Bool = false,
        parameters:[String:String]? = nil
    ) -> URLRequest {
        var request = URLRequest(url: URL(string: path, relativeTo: baseURL)!)
        request.httpMethod = httpMethod

        if let parameters = parameters {
            var components = URLComponents(url: request.url!, resolvingAgainstBaseURL: true)!
            components.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
            request.url = components.url
        }

        if (needToken) {
            guard let authToken = OAuth2TokenStorage().token else {
                return request
            }
            request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        }
        return request
    }
}
