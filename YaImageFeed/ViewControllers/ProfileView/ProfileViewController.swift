//
//  ProfileViewController.swift
//  YaImageFeed
//
//  Created by Сергей Денисенко on 03.04.2023.
//

import UIKit

final class ProfileViewController: UIViewController, ProfileViewControllerProtocol {

    var presenter: ProfileViewPresenterProtocol?

    private lazy var profileView: ProfileView = {
        let view = ProfileView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.viewController = self
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter?.viewDidLoad()
        setupView()
    }

    func updateAvatar(image: UIImage) {
        profileView.profileView.image = image
    }

    func updateProfile(profile: Profile) {
        profileView.updateProfileView(profile: profile)
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
