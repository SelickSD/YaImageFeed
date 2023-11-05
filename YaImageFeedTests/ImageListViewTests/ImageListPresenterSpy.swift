//
//  ImageListPresenterSpy.swift
//  YaImageFeedTests
//
//  Created by Сергей Денисенко on 05.11.2023.
//

import YaImageFeed
import UIKit

final class ImageListPresenterSpy: ImagesListPresenterProtocol {

    var viewDidLoadCalled: Bool = false
    var view: YaImageFeed.ImagesListViewControlledProtocol?

    func viewDidLoad() {
        viewDidLoadCalled = true
    }

    func getUrlLargeString(index: Int) -> String {
return ""
    }

    func getUrlThumbString(index: Int) -> String {
        return ""
    }

    func getValueCount() -> (oldCount: Int, newCount: Int) {
        return (0, 0)
    }

    func getCell(cell: YaImageFeed.ImagesListCell, index: Int) {

    }

    func photosCount() -> Int {
        return 0
    }

    func heightForRowAt(index: Int, imageInsets: UIEdgeInsets, imageViewWidth: CGFloat) -> CGFloat {
        return CGFloat()
    }

    func checkNextPhoto(index: Int) {

    }

    func changeLike(index: Int) {

    }
}
