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

    func viewDidLoad() {
        guard let profileImageURL = ProfileImageService.shared.profileImageURL else { return }
        let image = UIImageView()
        image.kf.setImage(with: profileImageURL,
                          placeholder: nil,
                          options: nil,
                          completionHandler: { [weak self] result in
            guard self != nil else { return }
            switch result {
            case .success(let value):
                self?.view?.updateAvatar(image: value.image)
            case .failure(let error):
                print("Фотография не загружена: \(error)")
            }
        })

        guard let profile = profileService.profile else {return}
        view?.updateProfile(profile: profile)
    }
}
