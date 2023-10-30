//
//  ProfileViewController.swift
//  YaImageFeed
//
//  Created by Сергей Денисенко on 03.04.2023.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {

    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    private let alertPresenter = AlertPresenter()

    private lazy var profileView: ProfileView = {
        let view = ProfileView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.viewController = self
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
        updateAvatar()

        if let profile = profileService.profile {
            profileView.updateProfileView(profile: profile)
        }
        setupView()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.profileImageURL else { return }
        profileView.profileView.kf.setImage(with: profileImageURL)
    }

    private func setupView() {
        view.addSubview(profileView)

        NSLayoutConstraint.activate([
            profileView.topAnchor.constraint(equalTo: view.topAnchor),
            profileView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            profileView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            profileView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
}
