//
//  ProfileViewControllerProtocol.swift
//  YaImageFeed
//
//  Created by Сергей Денисенко on 30.10.2023.
//

import UIKit

public protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfileViewPresenterProtocol? { get set }
    func updateAvatar(image: UIImage)
    func updateProfile(profile: Profile)
}
