//
//  UrlsResult.swift
//  YaImageFeed
//
//  Created by Сергей Денисенко on 09.10.2023.
//

import Foundation

struct UrlsResult: Codable {
    let fullLink: String?
    let smallLink: String?
    let thumbLink: String?

    private enum CodingKeys : String, CodingKey {
        case fullLink = "full"
        case smallLink = "small"
        case thumbLink = "thumb"
    }
}
