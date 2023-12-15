//
//  WebViewPresenterSpy.swift
//  YaImageFeedTests
//
//  Created by Сергей Денисенко on 25.10.2023.
//

import YaImageFeed
import Foundation

final class WebViewPresenterSpy: WebViewPresenterProtocol {

    var viewDidLoadCalled: Bool = false
    var view: WebViewViewControllerProtocol?

    func viewDidLoad() {
        viewDidLoadCalled = true
    }

    func didUpdateProgressValue(_ newValue: Double) {

    }

    func code(from url: URL) -> String? {
        return nil
    }

    func didTapBackButton(_ vc: YaImageFeed.WebViewViewControllerProtocol) {

    }

    func webViewViewController(_ vc: YaImageFeed.WebViewViewControllerProtocol, didAuthenticateWithCode code: String) {
        
    }
}
