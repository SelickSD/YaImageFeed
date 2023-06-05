//
//  AuthViewController.swift
//  YaImageFeed
//
//  Created by Сергей Денисенко on 23.04.2023.
//

import UIKit

class AuthViewController: UIViewController {

    private let showWebViewSegueIdentifier = "ShowWebView"
    private let oauth2Service = OAuth2Service()
    private let oauth2TokenStorage = OAuth2TokenStorage()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == showWebViewSegueIdentifier {
            guard
                let webViewViewController = segue.destination as? WebViewViewController
            else { fatalError("Failed to prepare for \(showWebViewSegueIdentifier)") }
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

//MARK: - WebViewViewControllerDelegate

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {

        oauth2Service.fetchOAuthToken(code) { [weak self] result in

            guard let self = self else { return }

            switch result {
            case .success(let authToken):
                self.oauth2TokenStorage.token = authToken
                    //   print("Access token saved \(authToken)")
            case .failure(let error):
                print("Failed to fetch access token: \(error)")
            }
        }
    }

    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
