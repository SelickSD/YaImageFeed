//
//  LikeUpdateResult.swift
//  YaImageFeed
//
//  Created by Сергей Денисенко on 15.10.2023.
//

import Foundation

struct LikeUpdateResult: Codable {
    let photo: LikedPhoto
}

struct LikedPhoto: Codable {
    let id: String
}
