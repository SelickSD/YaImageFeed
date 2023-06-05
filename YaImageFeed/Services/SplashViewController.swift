//
//  SplashViewController.swift
//  YaImageFeed
//
//  Created by Сергей Денисенко on 05.06.2023.
//

import UIKit

class SplashViewController: UIViewController {

    private let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"

    private let oauth2Service = OAuth2Service()
    private let oauth2TokenStorage = OAuth2TokenStorage()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let token = oauth2TokenStorage.token {
            performSegue(withIdentifier: showAuthenticationScreenSegueIdentifier, sender: nil)
//            switchToTabBarController()
        } else {
            performSegue(withIdentifier: showAuthenticationScreenSegueIdentifier, sender: nil)
        }
    }

    private func checkToken () -> Bool {
        return true
    }

    private func switchToTabBarController() {
        // Получаем экземпляр `Window` приложения
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }

        // Cоздаём экземпляр нужного контроллера из Storyboard с помощью ранее заданного идентификатора.
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")

        // Установим в `rootViewController` полученный контроллер
        window.rootViewController = tabBarController
    }

}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        oauth2Service.fetchOAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let authToken):
                self.oauth2TokenStorage.token = authToken
                self.switchToTabBarController()
            case .failure(let error):
                print("Failed to fetch access token: \(error)")
            }
        }
    }
}

extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Проверим, что переходим на авторизацию
        if segue.identifier == showAuthenticationScreenSegueIdentifier {

            // Доберёмся до первого контроллера в навигации. Мы помним, что в программировании отсчёт начинается с 0?
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else { fatalError("Failed to prepare for \(showAuthenticationScreenSegueIdentifier)") }

            // Установим делегатом контроллера наш SplashViewController
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}
