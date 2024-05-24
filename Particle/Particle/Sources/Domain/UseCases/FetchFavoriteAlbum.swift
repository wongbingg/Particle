//
//  FetchFavoriteAlbum.swift
//  Particle
//
//  Created by 이원빈 on 5/24/24.
//

import RxSwift
import Photos

protocol FetchFavoriteAlbum {
    func execute() -> [PHAsset]
}

final class DefaultFetchFavoriteAlbum: FetchFavoriteAlbum {
    private let photoRepository: PhotoRepository
    
    init(photoRepository: PhotoRepository) {
        self.photoRepository = photoRepository
    }
    
    func execute() -> [PHAsset] {
        photoRepository.fetchFavoritePhotos()
    }
}
