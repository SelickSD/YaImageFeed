//
//  ProfileView.swift
//  YaImageFeed
//
//  Created by Сергей Денисенко on 30.10.2023.
//

import UIKit

class ProfileView: UIView {
    
    private let alertPresenter = AlertPresenter()
    weak var viewController: ProfileViewController?
    
    lazy var profileView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 35
        view.clipsToBounds = true
        view.image = UIImage(named: "PersonCircle")
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Екатерина Новикова"
        label.font = UIFont(name: "Helvetica Neue", size: 23)
        label.textColor = .ypWhite
        return label
    }()
    
    private lazy var loginLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "@ekaterina_nov"
        label.font = UIFont(name: "Helvetica Neue", size: 13)
        label.textColor = .ypGray
        return label
    }()
    
    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Hello, World!"
        label.font = UIFont(name: "Helvetica Neue", size: 13)
        label.textColor = .ypWhite
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var exitButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "ExitButton"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(didTapExitButton), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateProfileView(profile: Profile) {
        nameLabel.text = profile.name
        loginLabel.text = profile.loginName
        statusLabel.text = profile.bio
    }
    
    private func setupView() {
        self.addSubview(profileView)
        self.addSubview(nameLabel)
        self.addSubview(loginLabel)
        self.addSubview(statusLabel)
        self.addSubview(exitButton)
        
        NSLayoutConstraint.activate([
            profileView.heightAnchor.constraint(equalToConstant: 70),
            profileView.widthAnchor.constraint(equalToConstant: 70),
            profileView.topAnchor.constraint(equalTo: self.topAnchor, constant: 76),
            profileView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            
            nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            nameLabel.topAnchor.constraint(equalTo: profileView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: profileView.leadingAnchor),
            
            loginLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            loginLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            loginLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            statusLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 8),
            statusLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            statusLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            exitButton.heightAnchor.constraint(equalToConstant: 24),
            exitButton.widthAnchor.constraint(equalToConstant: 24),
            exitButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 99),
            exitButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24)
        ])
    }
    
    @objc private func didTapExitButton() {
        
        guard let viewController = self.viewController else {return}
        
        let alert: [UIAlertAction] = [
            UIAlertAction(title: "Да", style: .default, handler: { _ in
                OAuth2TokenStorage.clean()
                viewController.present(SplashViewController(), animated: true, completion: nil) }),
            UIAlertAction(title: "Нет", style: .default, handler: { _ in })
        ]
        alertPresenter.showAlert(viewController: viewController, title: "Уверены что хотите выйти?", message: "Остановитесь!", alertAction: alert)
    }
}
