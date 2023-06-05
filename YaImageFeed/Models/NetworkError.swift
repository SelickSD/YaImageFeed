//
//  NetworkError.swift
//  YaImageFeed
//
//  Created by Сергей Денисенко on 05.06.2023.
//

import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}
