//
//  WebViewViewController.swift
//  YaImageFeed
//
//  Created by Сергей Денисенко on 23.04.2023.
//

import UIKit
import WebKit

class WebViewViewController: UIViewController {

    @IBOutlet private var webView: WKWebView!
    @IBOutlet private var backButton: UIButton!

    private let constants = Constants()

    override func viewDidLoad() {
        super.viewDidLoad()

        var urlComponents = URLComponents(url: constants.DefaultBaseURL, resolvingAgainstBaseURL: true)!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: constants.AccessKey),
            URLQueryItem(name: "redirect_uri", value: constants.RedirectURI),
           URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: constants.AccessScope)
         ]
         let url = urlComponents.url!

        let request = URLRequest(url: url)
        webView.load(request) 
    }


    @IBAction private func didTapBackButton(_ sender: Any) {
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
