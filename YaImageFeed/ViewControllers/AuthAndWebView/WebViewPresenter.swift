//
//  WebViewPresenter.swift
//  YaImageFeed
//
//  Created by Сергей Денисенко on 25.10.2023.
//

import Foundation

final class WebViewPresenter: WebViewPresenterProtocol {

    var authHelper: AuthHelperProtocol
    weak var view: WebViewViewControllerProtocol?

    init(authHelper: AuthHelperProtocol) {
        self.authHelper = authHelper
    }

    func viewDidLoad() {
        let request = authHelper.authRequest()
        view?.load(request: request)
        didUpdateProgressValue(0)
    }

    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)

        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldHideProgress)
    }

    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }

    func code(from url: URL) -> String? {
        authHelper.code(from: url)
    }
}
