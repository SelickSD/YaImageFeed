//
//  SplashViewController.swift
//  YaImageFeed
//
//  Created by Сергей Денисенко on 05.06.2023.
//

import UIKit
import ProgressHUD

class SplashViewController: UIViewController {

    private let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    private let oauth2Service = OAuth2Service.shared
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let alertPresenter = AlertPresenter()

    private lazy var splashView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "Vector")
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let _ = oauth2Service.authToken {
            fetchProfile()
        } else {
            switchToAuthViewController()
        }
    }

    private func switchToAuthViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        guard let authViewController = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController else { return }

        authViewController.delegate = self
        authViewController.modalPresentationStyle = .fullScreen
        present(authViewController, animated: true, completion: nil)
    }

    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }

        let tabBarController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }

    private func setupView() {
        view.backgroundColor = .ypBlack
        view.addSubview(splashView)

        NSLayoutConstraint.activate([
            splashView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            splashView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

//MARK: - AuthViewControllerDelegate
extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }

            UIBlockingProgressHUD.show()
            self.fetchOAuthToken(code)
        }
    }

    private func fetchOAuthToken(_ code: String) {
        oauth2Service.fetchOAuthToken(code) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success:
                self.fetchProfile()

            case .failure:
                UIBlockingProgressHUD.dismiss()
                let alert = [UIAlertAction(title: "ОК", style: .default)]
                alertPresenter.showAlert(viewController: self, title: "Что-то пошло не так",
                                         message: "Не удалось войти в систему",
                                         alertAction: alert)
                break
            }
        }
    }

    private func fetchProfile() {
        profileService.fetchProfile() { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let profile):
                self.fetchProfileImage(username: profile.username)

            case .failure:
                UIBlockingProgressHUD.dismiss()
                let alert = [UIAlertAction(title: "Не удалось войти в систему", style: .default)]
                alertPresenter.showAlert(viewController: self, title: "Что-то пошло не так",
                                         message: "Не удалось войти в систему",
                                         alertAction: alert)
                break
            }
        }
    }

    private func fetchProfileImage(username: String) {
        profileImageService.fetchProfileImageURL(username: username) { [weak self] result in
            guard let self = self else { return }

            UIBlockingProgressHUD.dismiss()

            switch result {
            case .success:
                self.switchToTabBarController()
                
            case .failure:
                let alert = [UIAlertAction(title: "ОК", style: .default)]
                alertPresenter.showAlert(viewController: self, title: "Что-то пошло не так",
                                         message: "Не удалось войти в систему",
                                         alertAction: alert)
                break
            }
        }
    }
}
