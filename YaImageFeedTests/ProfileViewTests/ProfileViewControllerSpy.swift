//
//  ProfileViewControllerSpy.swift
//  YaImageFeedTests
//
//  Created by Сергей Денисенко on 05.11.2023.
//

import YaImageFeed
import UIKit

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {

    var didAvatarUpdate: Bool = false

    var presenter: YaImageFeed.ProfileViewPresenterProtocol?

    func updateAvatar(image: UIImage) {
        didAvatarUpdate = true
    }

    func updateProfile(profile: YaImageFeed.Profile) {
    }
}
