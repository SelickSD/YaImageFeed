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
                forName: ImagesListService.didChangeNotification,
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard let viewController = segue.destination as? SingleImageViewController,
                  let image = UIImage(named: "StubSingle"),
                  let index = tableView.indexPathForSelectedRow?.row else { return }
            
            let urlString = URL(string: photos[index].largeImageURL)
            viewController.photoURL = URL.resizedImageURL(urlToResized: urlString)
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
                let indexPath = (oldCount ..< newCount).map { IndexPath(item: $0, section: 0) }
                self.tableView.insertRows(at: indexPath, with: .automatic)
            } completion: { _ in }
        }
    }
    
    private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let urlToResized = URL(string: photos[indexPath.row].thumbImageURL) else {return}

        let url = URL.resizedImageURL(urlToResized: urlToResized)
        
        cell.cellImage.kf.indicatorType = .custom(indicator: CustomActivityIndicator())
        cell.cellImage.kf.setImage(
            with:url,
            placeholder: UIImage(named: "Stub"),
            options: nil,
            completionHandler:{ [weak self] result in
                guard self != nil else { return }
                switch result {
                case .success(_):
                    cell.cellImage.contentMode = .scaleAspectFill
                    self?.tableView.reloadRows(at: [indexPath], with: .automatic)
                case .failure(let error):
                    print("Ошибка: \(error)")
                }
            }
        )
        cell.dataLabel.text = dateFormatter.string(from: photos[indexPath.row].createdAt ?? Date())
        cell.likeButton.setImage(UIImage(named: photos[indexPath.row].isLiked ? "FavoritesActive" : "FavoritesNoActive"), for: .normal)
        cell.delegate = self
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

        imageListCell.cellImage.layer.cornerRadius = 16
        imageListCell.cellImage.image = UIImage(named: "Stub")
        imageListCell.cellImage.clipsToBounds = true
        
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

// MARK: ImagesListCellDelegate
extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        print(#function)
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        imagesListService.changeLike(photoId: photo.id, isLike: photo.isLiked, index: indexPath.row) {[weak self] result in
            switch result {
            case .success(let photoID):
                print("LikeService обновил лайк в \(photoID)")
                self?.tableView.reloadData()
            case .failure:
                print("Что-то не получилось поставить лайк в \(indexPath)")
            }
        }
    }
}
