//
//  ImagesListPresenter.swift
//  YaImageFeed
//
//  Created by Сергей Денисенко on 30.10.2023.
//

import UIKit
import Kingfisher

class ImagesListPresenter: ImagesListPresenterProtocol {
    weak var view: ImagesListViewControlledProtocol?

    private var imagesListServiceObserver: NSObjectProtocol?
    private let imagesListService = ImagesListService.shared
    private var photos: [Photo] = []

    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()

    init() {

        imagesListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self
            else { return }
            self.view?.updateTableViewAnimated()
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func viewDidLoad() {
        DispatchQueue.main.async {
            if self.photos.count == 0 {
                self.imagesListService.fetchPhotosNextPage()
            }
        }
    }

    func getUrlLargeString(index: Int) -> String {
        photos[index].largeImageURL
    }

    func getUrlThumbString(index: Int) -> String {
        photos[index].thumbImageURL
    }

    func getCell(cell: ImagesListCell, index: Int) {
        guard let urlToResized = URL(string: photos[index].thumbImageURL) else { return }
        let url = URL.resizedImageURL(urlToResized: urlToResized)

        let processor = RoundCornerImageProcessor(cornerRadius: 16)
        let options: KingfisherOptionsInfo = [
            .backgroundDecode,
            .processor(processor)
        ]

        cell.cellImage.kf.indicatorType = .custom(indicator: CustomActivityIndicator())
        DispatchQueue.main.async {
            cell.cellImage.kf.setImage(
                with:url,
                placeholder: UIImage(named: "Stub"),
                options: options,
                completionHandler:{ [weak self] result in
                    guard self != nil else { return }
                    switch result {
                    case .success(let value):
                            cell.cellImage.image = value.image
                            cell.cellImage.contentMode = .scaleAspectFill
                            print(value.cacheType)
                    case .failure(let error):
                        print("Ошибка: \(error)")
                    }
                }
            )
        }
        cell.dataLabel.text = dateFormatter.string(from: photos[index].createdAt ?? Date())
        cell.likeButton.setImage(UIImage(named: photos[index].isLiked ? "FavoritesActive" : "FavoritesNoActive"), for: .normal)
    }

    func getValueCount() -> (oldCount: Int, newCount: Int) {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos

        return (oldCount, newCount)
    }

    func photosCount() -> Int {
        photos.count
    }

    func heightForRowAt(index: Int, top: CGFloat, bottom: CGFloat, imageViewWidth: CGFloat) -> CGFloat {
        guard index < imagesListService.photos.count else { return CGFloat() }

        let image = photos[index]
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + top + bottom
        return cellHeight
    }

    func checkNextPhoto(index: Int) {
        if index >= photos.count - 1 {
            imagesListService.fetchPhotosNextPage()
        }
    }

    func changeLike(index: Int) {

        let photo = photos[index]
        imagesListService.changeLike(photoId: photo.id, isLike: photo.isLiked, index: index) {[weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let photoID):
                print("LikeService обновил лайк в \(photoID)")
                self.view?.reloadDataTableView()
            case .failure:
                print("Что-то не получилось поставить лайк в \(index)")
            }
        }
    }
}
