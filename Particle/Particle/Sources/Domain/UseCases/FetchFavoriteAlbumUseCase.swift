//
//  FetchFavoriteAlbumUseCase.swift
//  Particle
//
//  Created by 이원빈 on 5/24/24.
//

import RxSwift
import Photos

protocol FetchFavoriteAlbumUseCase {
    func execute() -> [PHAsset]
}

final class DefaultFetchFavoriteAlbumUseCase: FetchFavoriteAlbumUseCase {
    private let photoRepository: PhotoRepository
    
    init(photoRepository: PhotoRepository) {
        self.photoRepository = photoRepository
    }
    
    func execute() -> [PHAsset] {
        photoRepository.fetchFavoritePhotos()
    }
}
