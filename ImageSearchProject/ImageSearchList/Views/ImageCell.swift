//
//  ImageCell.swift
//  ImageSearchProject
//
//  Created by Eric Rado on 7/9/21.
//

import UIKit
import Kingfisher

final class ImageCell: UICollectionViewCell {
    
    // MARK: - UI properties
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.textAlignment = .center
        return label
    }()
    
    private let activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .medium)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.color = .gray
        return activityIndicatorView
    }()
    
    // MARK: - Properties
    var viewModel: ImageCellViewModel? {
        didSet {
            configure()
        }
    }
    
    // MARK: - Initializer method
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI helper methods
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        titleLabel.text = nil
    }
    
    private func setupView() {
        addSubview(imageView)
        addSubview(activityIndicatorView)
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80),
        ])
        
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            activityIndicatorView.heightAnchor.constraint(equalToConstant: 50),
            activityIndicatorView.widthAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
    
    private func configure() {
        guard let viewModel = viewModel else { return }
        
        titleLabel.text = viewModel.title
        activityIndicatorView.startAnimating()
        imageView.kf.setImage(with: URL(string: viewModel.urlString), placeholder: nil, options: nil) { [weak self] result in
            switch result {
            case .success:
                break
            case .failure:
                self?.imageView.image = UIImage(named: "NotFound")
            }
            self?.activityIndicatorView.stopAnimating()
        }
    }
}
