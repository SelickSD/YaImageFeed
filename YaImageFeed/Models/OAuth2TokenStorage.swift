//
//  OAuth2TokenStorage.swift
//  YaImageFeed
//
//  Created by Сергей Денисенко on 29.05.2023.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {

    private enum Keys: String {
        case token
    }

    var token: String? {
        get {
            return KeychainWrapper.standard.string(forKey: "Auth token")
        }
        set(newValue) {
            guard let token = newValue else { return }
            let isSuccess = KeychainWrapper.standard.set(token, forKey: "Auth token")
            guard isSuccess else { return }
        }
    }

    private let userDefaults = UserDefaults.standard
}
