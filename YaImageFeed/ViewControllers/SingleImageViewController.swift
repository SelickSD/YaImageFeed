//
//  SingleImageViewController.swift
//  YaImageFeed
//
//  Created by Сергей Денисенко on 11.04.2023.
//

import UIKit
import Kingfisher
import ProgressHUD

final class SingleImageViewController: UIViewController {

    private static var window: UIWindow? {
        return UIApplication.shared.windows.first
    }

    var image: UIImage! {
        didSet {
            guard isViewLoaded else { return }
            imageView.image = image
            rescaleAndCenterImageInScrollView(image: image)
        }
    }

    var photoURL: URL!

    @IBOutlet private var backwardButton: UIButton!
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var shareButton: UIButton!
    @IBOutlet weak private var imageView: UIImageView!

    private let alertPresenter = AlertPresenter()

    override func viewDidLoad() {
        super.viewDidLoad()

        loadImage()
        //        imageView.image = image
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25

    }

    @IBAction private func didTapBackwardButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction private func didTapShareButton(_ sender: Any) {
        guard let image = image else { return }
        let share = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(share, animated: true)

    }

    private func loadImage() {

        SingleImageViewController.window?.isUserInteractionEnabled = false

        UIBlockingProgressHUD.show()
        let placeholderImage = UIImage(named: "Stub")
        let placeholderColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        let processor = RoundCornerImageProcessor(cornerRadius: 16)
        let options: KingfisherOptionsInfo = [
            .backgroundDecode,
            .onFailureImage(placeholderImage?.kf.image(withBlendMode: .normal, backgroundColor: placeholderColor)),
            .processor(processor)
        ]
        let alert: [UIAlertAction] = [
            UIAlertAction(title: "Не надо", style: .default, handler: { _ in
            }),
            UIAlertAction(title: "Повторить", style: .default, handler: { _ in
                self.loadImage()})
        ]

        self.imageView.kf.indicatorType = .activity
        self.imageView.kf.setImage(
            with: photoURL,
            placeholder: placeholderImage,
            options: options,
            completionHandler:{ [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let imageResult):
                    UIBlockingProgressHUD.dismiss()
                    rescaleAndCenterImageInScrollView(image: imageResult.image)

                case .failure(_):
                    UIBlockingProgressHUD.dismiss()

                    alertPresenter.showAlert(viewController: self, title: "Что-то пошло не так.",
                                             message: "Попробовать ещё раз?",
                                             alertAction: alert)
                }
            }
        )
        rescaleAndCenterImageInScrollView(image: imageView.image ?? image)
    }

    private func showError() {
        
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
}

//MARK: -- UIScrollViewDelegate
extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}


