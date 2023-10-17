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
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            // Массив полученных записей удаляем из хранилища.
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }

    private let userDefaults = UserDefaults.standard
}
