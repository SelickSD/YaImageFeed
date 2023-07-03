//
//  ProfileViewController.swift
//  YaImageFeed
//
//  Created by Сергей Денисенко on 03.04.2023.
//

import UIKit

final class ProfileViewController: UIViewController, AlertPresenterDelegate {

    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private var profileImageServiceObserver: NSObjectProtocol?

    private lazy var profileView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 35
        view.image = UIImage(named: "PersonCircle")
        return view
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Екатерина Новикова"
        label.font = UIFont(name: "Helvetica Neue", size: 23)
        label.textColor = .ypWhite
        return label
    }()

    private lazy var loginLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "@ekaterina_nov"
        label.font = UIFont(name: "Helvetica Neue", size: 13)
        label.textColor = .ypGray
        return label
    }()

    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Hello, World!"
        label.font = UIFont(name: "Helvetica Neue", size: 13)
        label.textColor = .ypWhite
        label.numberOfLines = 0
        return label
    }()

    private lazy var exitButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "ExitButton"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(didTapExitButton), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        profileImageServiceObserver = NotificationCenter.default    // 2
            .addObserver(
                forName: ProfileImageService.DidChangeNotification, // 3
                object: nil,                                        // 4
                queue: .main                                        // 5
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()                                 // 6
            }
        updateAvatar()

        if let profile = profileService.profile {
            updateProfileDetails(profile: profile)
        }

//        if let data = profileImageService.avatarData {
//            updateProfileImageDetails(avatarData: data)
//        }
        
        setupView()
    }

    private func updateProfileDetails(profile: Profile) {
        nameLabel.text = profile.name
        loginLabel.text = profile.loginName
        statusLabel.text = profile.bio
    }

    private func updateProfileImageDetails(avatarData: UIImage) {
        profileView.image = avatarData
    }

    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.profileImageURL
//            let url = URL(string: profileImageURL)
        else { return }
    }

    private func setupView() {
        view.addSubview(profileView)
        view.addSubview(nameLabel)
        view.addSubview(loginLabel)
        view.addSubview(statusLabel)
        view.addSubview(exitButton)

        NSLayoutConstraint.activate([
            profileView.heightAnchor.constraint(equalToConstant: 70),
            profileView.widthAnchor.constraint(equalToConstant: 70),
            profileView.topAnchor.constraint(equalTo: view.topAnchor, constant: 76),
            profileView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameLabel.topAnchor.constraint(equalTo: profileView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: profileView.leadingAnchor),

            loginLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            loginLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            loginLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),

            statusLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 8),
            statusLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            statusLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),

            exitButton.heightAnchor.constraint(equalToConstant: 24),
            exitButton.widthAnchor.constraint(equalToConstant: 24),
            exitButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 99),
            exitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }
    @objc private func didTapExitButton() {

        print(#function)

    }
}
