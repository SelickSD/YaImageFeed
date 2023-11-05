//
//  ImagesListPresenterProtocol.swift
//  YaImageFeed
//
//  Created by Сергей Денисенко on 30.10.2023.
//

import UIKit

public protocol ImagesListPresenterProtocol {
    var view: ImagesListViewControlledProtocol? { get set }
    func viewDidLoad()
    func getUrlLargeString(index: Int) -> String
    func getUrlThumbString(index: Int) -> String
    func getValueCount() -> (oldCount: Int, newCount: Int)
    func getCell(cell: ImagesListCell, index: Int)
    func photosCount() -> Int
    func heightForRowAt(index: Int, imageInsets: UIEdgeInsets, imageViewWidth: CGFloat) -> CGFloat
    func checkNextPhoto(index: Int)
    func changeLike(index: Int)
}
