//
//  OAuth2TokenStorage.swift
//  YaImageFeed
//
//  Created by Сергей Денисенко on 29.05.2023.
//

import Foundation
import SwiftKeychainWrapper
import WebKit

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

    static func clean() {

        guard KeychainWrapper.standard.removeObject(forKey: "Auth token") else {return}

        // Очищаем все куки из хранилища.
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        // Запрашиваем все данные из локального хранилища.
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) {
            // Массив полученных записей удаляем из хранилища.
            $0.forEach {
                WKWebsiteDataStore.default().removeData(ofTypes: $0.dataTypes, for: [$0], completionHandler: {})
            }
        }
    }

    private let userDefaults = UserDefaults.standard
}
