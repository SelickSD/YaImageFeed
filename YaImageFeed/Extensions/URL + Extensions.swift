//
//  URL + Extensions.swift
//  YaImageFeed
//
//  Created by Сергей Денисенко on 10.10.2023.
//

import Foundation

extension URL {
    static func resizedImageURL(urlToResized: URL?) -> URL? {

        if let urlString = urlToResized?.absoluteString {
            let imageUrlString = urlString.components(separatedBy: "._")[0] + "._V0_UX600_.jpg"
            return URL(string: imageUrlString)
        }
        return urlToResized
    }
}
