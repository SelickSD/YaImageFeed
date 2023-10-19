//
//  CustomActivityIndicator.swift
//  YaImageFeed
//
//  Created by Сергей Денисенко on 19.10.2023.
//

import Kingfisher
import UIKit
import ProgressHUD

class CustomActivityIndicator: Indicator {

    var view: Kingfisher.IndicatorView

    init() {
        view = Kingfisher.IndicatorView()
    }

    func startAnimatingView() {
        ProgressHUD.colorHUD = .ypBlack
        ProgressHUD.colorBackground = .ypWhite
        ProgressHUD.animationType = .systemActivityIndicator
        ProgressHUD.colorAnimation = .ypBlack
        ProgressHUD.colorProgress = .ypBlack
        ProgressHUD.show()
    }

    func stopAnimatingView() {
        ProgressHUD.dismiss()
    }
}
