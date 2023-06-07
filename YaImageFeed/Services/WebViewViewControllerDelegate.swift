//
//  WebViewViewControllerDelegate.swift
//  YaImageFeed
//
//  Created by Сергей Денисенко on 23.04.2023.
//

import Foundation

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}
