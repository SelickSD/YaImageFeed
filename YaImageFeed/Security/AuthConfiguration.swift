//
//  Constants.swift
//  YaImageFeed
//
//  Created by Сергей Денисенко on 22.04.2023.
//

import Foundation

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String

    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, authURLString: String, defaultBaseURL: URL) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }

    static let standard = AuthConfiguration(accessKey: "mdiyQwfFaXgj71MPg000lIJGuSeT5yylpY-AhT9qNGg",
                                            secretKey: "m5EhcUJqHPusWytAw73XhvwV5HzSb8skBzyTDTFzWfs",
                                            redirectURI: "urn:ietf:wg:oauth:2.0:oob",
                                            accessScope: "public+read_user+write_likes",
                                            authURLString: "https://unsplash.com/oauth/authorize",
                                            defaultBaseURL: URL(string: "https://api.unsplash.com")!)
}

