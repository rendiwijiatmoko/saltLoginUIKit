//
//  HomeViewController.swift
//  SaltLoginUIKit
//
//  Created by Rendi Wijiatmoko on 18/11/22.
//

import UIKit

class HomeViewController: UIViewController {

    // MARK: - UI Components
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "photo")
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        
        return imageView
    }()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "EVA"
        return label
    }()
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        title = "Home"
        self.navigationItem.setHidesBackButton(true, animated: false)
        setupUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        // MARK: - Image
        self.view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
        
        // MARK: - Name
        self.view.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 24),
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }

}

