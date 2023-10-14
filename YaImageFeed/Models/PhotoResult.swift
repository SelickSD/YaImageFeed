//
//  PhotoResult.swift
//  YaImageFeed
//
//  Created by Сергей Денисенко on 09.10.2023.
//

import Foundation

struct PhotoResult: Codable {

    let id: String
    let createdAt: String
    let updatedAt: String
    let width: Int
    let height: Int
    let color: String
    let blurHash: String
    let likes: Int
    let isLiked: Bool
    let description: String?
    let urls: UrlsResult

    private enum CodingKeys : String, CodingKey {
        case id
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case width
        case height
        case color
        case blurHash = "blur_hash"
        case likes
        case isLiked = "liked_by_user"
        case description
        case urls
    }
}