//
//  ViewController.swift
//  YaImageFeed
//
//  Created by Сергей Денисенко on 27.02.2023.
//

import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {

    @IBOutlet private var tableView: UITableView!

    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private let imagesListService = ImagesListService.shared
    private var imagesListServiceObserver: NSObjectProtocol?
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    private var photos: [Photo] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        imagesListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.DidChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateTableViewAnimated()
            }

        DispatchQueue.main.async {
            if self.photos.count == 0 {
                self.imagesListService.fetchPhotosNextPage()
            }
        }

        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard let viewController = segue.destination as? SingleImageViewController,
                  let image = UIImage(named: "Stub")  else { return }
            viewController.image = image
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }

    private func updateTableViewAnimated() {

        let oldCount = photos.count
        let newCount = imagesListService.photos.count

        photos = imagesListService.photos

        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPath = (oldCount ..< newCount).map { i in
                    IndexPath(item: i, section: 0)
                }
                self.tableView.insertRows(at: indexPath, with: .automatic)
            } completion: { _ in }
        }
    }

    private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let urlToResized = URL(string: photos[indexPath.row].thumbImageURL) else {return}

        let url = URL.resizedImageURL(urlToResized: urlToResized)
        let placeholderImage = UIImage(named: "Stub")
        let placeholderColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        let processor = RoundCornerImageProcessor(cornerRadius: 16)
        let options: KingfisherOptionsInfo = [
            .backgroundDecode,
            .onFailureImage(placeholderImage?.kf.image(withBlendMode: .normal, backgroundColor: placeholderColor)),
            .processor(processor)
        ]
        cell.cellImage.kf.indicatorType = .activity
        cell.cellImage.kf.setImage(with:url,
                                   placeholder: placeholderImage,
                                   options: options,
                                   completionHandler:{ [weak self] result in
            guard self != nil else { return }
            switch result {
            case .success(let value):
                // Загрузка изображения прошла успешно
                print("Фотокарточка загружена: \(value.source.url?.absoluteString ?? "")")
                cell.cellImage.contentMode = .scaleAspectFill
                self?.tableView.reloadRows(at: [indexPath], with: .automatic)
            case .failure(let error):
                // Возникла ошибка при загрузке изображения
                print("Фотокарточка не загружена: \(error)")
            }
        })

        cell.dataLabel.text = dateFormatter.string(from: Date())
        cell.likeButton.setImage(UIImage(named: indexPath.row % 2 != 0 ? "FavoritesActive" : "FavoritesNoActive"), for: .normal)
    }
}

//MARK: extension UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
}

//MARK: extension UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)

        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }

        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        guard indexPath.row < imagesListService.photos.count else { return CGFloat() }

        let image = photos[indexPath.row]
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row >= photos.count - 1 {
            imagesListService.fetchPhotosNextPage()
        }
    }
}
