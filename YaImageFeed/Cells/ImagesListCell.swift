//
//  ImagesListCell.swift
//  YaImageFeed
//
//  Created by Сергей Денисенко on 21.03.2023.
//

import UIKit

final class ImagesListCell: UITableViewCell {

    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dataLabel: UILabel!
    @IBOutlet var cellImage: UIImageView!
}
