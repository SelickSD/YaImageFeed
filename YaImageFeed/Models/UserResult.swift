//
//  UserResult.swift
//  YaImageFeed
//
//  Created by Сергей Денисенко on 18.06.2023.
//

import Foundation

struct UserResult: Codable {
    let profileImageLink: ProfileImageLink

    private enum CodingKeys : String, CodingKey {
        case profileImageLink = "profile_image"
    }
}
