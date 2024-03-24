//
//  PagesViewController.swift
//  TrackerApp
//
//  Created by Эмилия on 23.01.2024.
//

import UIKit

//MARK: - PagesViewController
final class PagesViewController: UIViewController {
    
    //MARK: - Properties
    var descriptionText: String?
    var backgroundImage: UIImage?
    
    //MARK: - Private properties
    private let dataStorage = DataStorage.shared
    
    //MARK: - UI Components
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textColor = Color.black
        label.textAlignment = .center
        return label
    }()
    
    private lazy var skipButton: UIButton = {
        let button = UIButton()
        button.setTitle("Вот это технологии!", for: .normal)
        button.layer.cornerRadius = 16
        button.backgroundColor = Color.black
        button.addTarget(
            self,
            action: #selector(didTapButton),
            for: .touchUpInside)
        return button
    }()
    
    private var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    // MARK: - Private methods
    private func configure() {
        descriptionLabel.text = descriptionText
        backgroundImageView.image = backgroundImage
        addViews()
        layoutViews()
    }
    
    private func addViews() {
        [backgroundImageView,
         descriptionLabel,
         skipButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func layoutViews() {
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 432),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -304),
            skipButton.heightAnchor.constraint(equalToConstant: 60),
            skipButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            skipButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            skipButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 160)
        ])
    }
}

// MARK: - Extension
@objc extension PagesViewController {
    private func didTapButton() {
        guard let window = UIApplication.shared.windows.first else {
            fatalError("Invalid Configuration")
        }
        window.rootViewController = TabBarController()
        dataStorage.firstLaunchApplication = true
    }
}
