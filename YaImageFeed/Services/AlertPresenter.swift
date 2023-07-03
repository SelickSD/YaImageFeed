//
//  AlertPresenter.swift
//  YaImageFeed
//
//  Created by Сергей Денисенко on 02.07.2023.
//

import UIKit

class AlertPresenter {

    func showAlert(viewController: UIViewController, title: String,
                   message: String,
                   buttonText: String,
                   completion: @escaping (UIAlertAction) -> Void) {

        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: buttonText, style: .default, handler: completion)
        alert.addAction(action)

        viewController.present(alert, animated: true)
    }
}
