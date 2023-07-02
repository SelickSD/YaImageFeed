//
//  ProfileImageLink.swift
//  YaImageFeed
//
//  Created by Сергей Денисенко on 18.06.2023.
//

import Foundation

struct ProfileImageLink: Codable {
    let smallLink: URL

    var resizedImageURL: URL {
        let urlString = smallLink.absoluteString
        let imageUrlString = urlString.components(separatedBy: "._")[0] + "._V0_UX600_.jpg"
        guard let newURL = URL(string: imageUrlString) else {
            return smallLink
        }
        return newURL
    }

    private enum CodingKeys : String, CodingKey {
        case smallLink = "small"
    }

}
