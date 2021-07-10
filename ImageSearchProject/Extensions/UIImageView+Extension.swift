//
//  UIImageView+Extension.swift
//  ImageSearchProject
//
//  Created by Eric Rado on 7/10/21.
//

import UIKit

extension UIImageView {
    func loadImage(urlString: String?, networkManager: NetworkManager = NetworkManager()) {
        guard let urlString = urlString else { return }
        
        networkManager.requestImage(urlString) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self?.image = UIImage(data: data)
                case .failure:
                    break
                }
            }
        }
    }
}
