//
//  ImagesListViewControlledProtocol.swift
//  YaImageFeed
//
//  Created by Сергей Денисенко on 30.10.2023.
//

import UIKit

public protocol ImagesListViewControlledProtocol: AnyObject {
    var presenter: ImagesListPresenterProtocol? { get set }
    func reloadDataTableView()
    func updateTableViewAnimated()
}
