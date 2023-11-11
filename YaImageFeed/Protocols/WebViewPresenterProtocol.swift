//
//  WebViewPresenterProtocol.swift
//  YaImageFeed
//
//  Created by Сергей Денисенко on 25.10.2023.
//

import UIKit

public protocol WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol? { get set }
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
    func code(from url: URL) -> String?
    func didTapBackButton(_ vc: WebViewViewControllerProtocol)
    func webViewViewController(_ vc: WebViewViewControllerProtocol, didAuthenticateWithCode code: String)
}
