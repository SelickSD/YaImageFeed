//
//  ProfileImageLink.swift
//  YaImageFeed
//
//  Created by Сергей Денисенко on 18.06.2023.
//

import Foundation

struct ProfileImageLink: Codable {
    let smallLink: URL

    private enum CodingKeys : String, CodingKey {
        case smallLink = "small"
    }
}
