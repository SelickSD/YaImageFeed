//
//  OAuth2TokenStorage.swift
//  YaImageFeed
//
//  Created by Сергей Денисенко on 29.05.2023.
//

import Foundation

final class OAuth2TokenStorage {

    private enum Keys: String {
        case token
    }

    var token: String? {
        get {
            return userDefaults.string(forKey: Keys.token.rawValue)
        }
        set(newValue) {
            userDefaults.set(newValue, forKey: Keys.token.rawValue)
        }
    }

    private let userDefaults = UserDefaults.standard
}
