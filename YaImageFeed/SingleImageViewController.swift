//
//  SingleImageViewController.swift
//  YaImageFeed
//
//  Created by Сергей Денисенко on 11.04.2023.
//

import UIKit

class SingleImageViewController: UIViewController {

    var image: UIImage! {
        didSet {
            guard isViewLoaded else { return }
            imageView.image = image
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = image

    }

}
