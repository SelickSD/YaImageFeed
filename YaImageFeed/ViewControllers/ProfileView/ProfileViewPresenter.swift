//
//  ProfileViewPresenter.swift
//  YaImageFeed
//
//  Created by Сергей Денисенко on 30.10.2023.
//

import UIKit
import Kingfisher

class ProfileViewPresenter: ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol?
    private let profileImageService = ProfileImageService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    private let profileService = ProfileService.shared
    private let image: UIImageView

    init() {
        image = UIImageView()

        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self
            else { return }
            loadImage()
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func viewDidLoad() {

        guard let image = image.image else {return}
        view?.updateAvatar(image: image)

        guard let profile = profileService.profile else {return}
        view?.updateProfile(profile: profile)
    }

    private func loadImage() {
        guard let profileImageURL = ProfileImageService.shared.profileImageURL else { return }
        image.kf.setImage(with: profileImageURL,
                          placeholder: nil,
                          options: nil,
                          completionHandler: { [weak self] result in
            guard self != nil else { return }
            switch result {
            case .success(let value):
                self?.image.image = value.image
            case .failure(let error):
                print("Фотография не загружена: \(error)")
            }
        })
    }
}
