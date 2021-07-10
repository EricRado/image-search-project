//
//  ImageRepo.swift
//  ImageSearchProject
//
//  Created by Eric Rado on 7/9/21.
//

import Foundation

struct ImageRepo {
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func fetchImages(with input: String, completion: @escaping (Result<[Image], Error>) -> Void) {
        let imagesCompletionHandler: (Result<ImageResponseDTO, Error>) -> () = { result in
            switch result {
            case .success(let imageResponseDTO):
                let images = (imageResponseDTO.items ?? []).map { Image(dto: $0) }
                completion(.success(images))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        networkManager.request(GalleryEndpoint.search(input: input), completion: imagesCompletionHandler)
    }
}
