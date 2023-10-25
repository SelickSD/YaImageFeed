//
//  WebViewViewControllerSpy.swift
//  YaImageFeedTests
//
//  Created by Сергей Денисенко on 25.10.2023.
//

import YaImageFeed
import Foundation

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {

    var didRequestLoad: Bool = false
    var presenter: YaImageFeed.WebViewPresenterProtocol?

    func load(request: URLRequest) {
        didRequestLoad = true
    }

    func setProgressValue(_ newValue: Float) {

    }

    func setProgressHidden(_ isHidden: Bool) {
        
    }


}

