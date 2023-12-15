//
//  AuthHelperProtocol.swift
//  YaImageFeed
//
//  Created by Сергей Денисенко on 25.10.2023.
//

import Foundation

protocol AuthHelperProtocol {
    func authRequest() -> URLRequest
    func code(from url: URL) -> String?
} 
