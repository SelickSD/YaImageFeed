//
//  ViewController.swift
//  YaImageFeed
//
//  Created by Сергей Денисенко on 27.02.2023.
//

import UIKit

class ImagesListViewController: UIViewController {

    @IBOutlet private var tableView: UITableView!

    private let photosName: [String] = Array(0..<20).map{ "\($0)" } 

    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }

    func configCell(for cell: ImagesListCell) { }

}

//MARK: UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { }

}

//MARK: UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath) // 1

            guard let imageListCell = cell as? ImagesListCell else { // 2
                return UITableViewCell()
            }

            configCell(for: imageListCell) // 3
            return imageListCell // 4
        }


}
