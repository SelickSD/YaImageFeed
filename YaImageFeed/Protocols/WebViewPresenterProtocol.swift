//
//  WebViewPresenterProtocol.swift
//  YaImageFeed
//
//  Created by Сергей Денисенко on 25.10.2023.
//

import Foundation

public protocol WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol? { get set }
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
    func code(from url: URL) -> String?
}
