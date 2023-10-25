//
//  Constants.swift
//  YaImageFeed
//
//  Created by Сергей Денисенко on 22.04.2023.
//

import Foundation

let AccessKey: String = "mdiyQwfFaXgj71MPg000lIJGuSeT5yylpY-AhT9qNGg"
let SecretKey: String = "m5EhcUJqHPusWytAw73XhvwV5HzSb8skBzyTDTFzWfs"
let RedirectURI: String = "urn:ietf:wg:oauth:2.0:oob"
let AccessScope: String = "public+read_user+write_likes"

let DefaultBaseURL = URL(string: "https://api.unsplash.com")!
let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"

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

    static var standard: AuthConfiguration {
            return AuthConfiguration(accessKey: AccessKey,
                                     secretKey: SecretKey,
                                     redirectURI: RedirectURI,
                                     accessScope: AccessScope,
                                     authURLString: UnsplashAuthorizeURLString,
                                     defaultBaseURL: DefaultBaseURL)
        }
}

