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
                   alertAction: [UIAlertAction]) {

        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)

        alertAction.forEach { value in
            alert.addAction(value)
        }
        viewController.present(alert, animated: true)
    }
}
