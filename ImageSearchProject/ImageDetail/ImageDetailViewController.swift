//
//  ImageDetailViewController.swift
//  ImageSearchProject
//
//  Created by Eric Rado on 7/10/21.
//

import UIKit
import Kingfisher

final class ImageDetailViewController: UIViewController {
    // MARK: UI properties
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        return label
    }()
    
    private let activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .medium)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.color = .gray
        return activityIndicatorView
    }()
    
    // MARK: - Instance properties
    private let viewModel: ImageCellViewModel
    
    init(viewModel: ImageCellViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        navigationItem.title = viewModel.title
        
        view.addSubview(imageView)
        view.addSubview(activityIndicatorView)
        view.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)
        ])
        
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicatorView.heightAnchor.constraint(equalToConstant: 75),
            activityIndicatorView.widthAnchor.constraint(equalToConstant: 75),
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            descriptionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16)
        ])
        
        imageView.startAnimating()
        imageView.kf.setImage(with: URL(string: viewModel.urlString), placeholder: nil, options: nil) { [weak self] result in
            switch result {
            case .success:
                break
            case .failure:
                self?.imageView.image = UIImage(named: "NotFound")
            }
            self?.activityIndicatorView.stopAnimating()
        }
        
        let descriptionText = "Description : \(viewModel.description != "" ? viewModel.description : "N/A")"
        descriptionLabel.text = descriptionText
    }

}
