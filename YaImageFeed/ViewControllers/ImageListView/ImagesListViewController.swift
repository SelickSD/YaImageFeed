//
//  ViewController.swift
//  YaImageFeed
//
//  Created by Сергей Денисенко on 27.02.2023.
//

import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController, ImagesListViewControlledProtocol {

    var presenter: ImagesListPresenterProtocol?

    @IBOutlet private var tableView: UITableView!
    
    private let showSingleImageSegueIdentifier = "ShowSingleImage"

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let presenter = self.presenter else {return}
        if segue.identifier == showSingleImageSegueIdentifier {
            guard let viewController = segue.destination as? SingleImageViewController,
                  let image = UIImage(named: "StubSingle"),
                  let index = tableView.indexPathForSelectedRow?.row else { return }

            let urlString = URL(string: presenter.getUrlLargeString(index: index))
            viewController.photoURL = URL.resizedImageURL(urlToResized: urlString)
            viewController.image = image
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func updateTableViewAnimated() {
        guard let presenter = self.presenter else {return}
        let (oldCount, newCount) = presenter.getValueCount()

        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPath = (oldCount ..< newCount).map { IndexPath(item: $0, section: 0) }
                self.tableView.insertRows(at: indexPath, with: .automatic)
            } completion: { _ in }
        }
    }

    func reloadDataTableView() {
        tableView.reloadData()
    }
    
    private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let presenter = self.presenter else {return}

        presenter.getCell(cell: cell, index: indexPath.row)
        cell.delegate = self
        tableView.reloadRows(at: [indexPath], with: .automatic)
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
        guard let presenter = self.presenter else {return 0}
        return presenter.photosCount()
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
        guard let presenter = self.presenter,
              indexPath.row < presenter.photosCount() else { return CGFloat() }

        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let cellHeight = presenter.heightForRowAt(index: indexPath.row,
                                                  top: imageInsets.top,
                                                  bottom: imageInsets.bottom,
                                                  imageViewWidth: imageViewWidth)
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let presenter = self.presenter else {return}
        presenter.checkNextPhoto(index: indexPath.row)
    }
}

// MARK: ImagesListCellDelegate
extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let presenter = self.presenter,
              let indexPath = tableView.indexPath(for: cell) else { return }
        presenter.changeLike(index: indexPath.row)
    }
}
