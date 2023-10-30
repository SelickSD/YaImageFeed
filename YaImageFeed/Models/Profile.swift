//
//  struct Profile.swift
//  YaImageFeed
//
//  Created by Сергей Денисенко on 17.06.2023.
//

import Foundation

public struct Profile {
    let username: String
    let name: String
    var loginName: String {
        get {
            return "@" + username
        }
    }
    let bio: String
}
