//
//  Photo.swift
//  YaImageFeed
//
//  Created by Сергей Денисенко on 09.10.2023.
//

import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: String?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}
