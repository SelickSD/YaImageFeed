//
//  ImagesListCell.swift
//  YaImageFeed
//
//  Created by Сергей Денисенко on 21.03.2023.
//

import UIKit
import Kingfisher

public final class ImagesListCell: UITableViewCell {

    static let reuseIdentifier = "ImagesListCell"
    weak var delegate: ImagesListCellDelegate?
    
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dataLabel: UILabel!
    @IBOutlet var cellImage: UIImageView!

    public override func awakeFromNib() {
        super.awakeFromNib()
        
        likeButton.accessibilityIdentifier = "likeButtonToTap"

        cellImage.layer.cornerRadius = 16
        cellImage.clipsToBounds = true
        cellImage.image = UIImage(named: "Stub")
    }

    public override func prepareForReuse() {
        super.prepareForReuse()

        cellImage.kf.cancelDownloadTask()
    }

    @IBAction func didTapLikeButton(_ sender: Any) {
        delegate?.imageListCellDidTapLike(self)
    }
}
