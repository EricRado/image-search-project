//
//  UIImageView+Extension.swift
//  ImageSearchProject
//
//  Created by Eric Rado on 7/10/21.
//

import UIKit

extension UIImageView {
    func loadImage(urlString: String?, networkManager: NetworkManager = NetworkManager(), completion: @escaping () -> ()) {
        guard let urlStringUnwrapped = urlString, urlStringUnwrapped != "" else {
            completion()
            return
        }
        
        networkManager.requestImage(urlStringUnwrapped) { [weak self, urlStringUnwrapped] result in
            DispatchQueue.main.async {
                // if the captured url string does not match the parameter, network call has been
                // called twice on the image view
                if urlStringUnwrapped != (urlString ?? "") {
                    completion()
                    self?.image = nil
                    return
                }
            
            
                switch result {
                case .success(let data):
                    self?.image = UIImage(data: data)
                case .failure:
                    break
                }
                completion()
            }
        }
    }
}
