//
//  ProfileViewPresenterProtocol.swift
//  YaImageFeed
//
//  Created by Сергей Денисенко on 30.10.2023.
//

import Foundation

public protocol ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
}
