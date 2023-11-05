//
//  ProfilePresenterSpy.swift
//  YaImageFeedTests
//
//  Created by Сергей Денисенко on 05.11.2023.
//

import YaImageFeed
import Foundation

final class ProfilePresenterSpy: ProfileViewPresenterProtocol {

    var view: YaImageFeed.ProfileViewControllerProtocol?
    var viewDidLoadCalled: Bool = false

    func viewDidLoad() {
        viewDidLoadCalled = true
    }

    func didUpdateProgressValue(_ newValue: Double) {

    }

    func code(from url: URL) -> String? {
        return nil
    }
}

