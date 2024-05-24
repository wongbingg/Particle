//
//  FetchScreenshotAlbumUseCase.swift
//  Particle
//
//  Created by 이원빈 on 5/25/24.
//

import Photos

protocol FetchScreenshotAlbumUseCase {
    func execute() -> [PHAsset]
}

final class DefaultFetchScreenshotAlbumUseCase: FetchScreenshotAlbumUseCase {
    private let photoRepository: PhotoRepository
    
    init(photoRepository: PhotoRepository) {
        self.photoRepository = photoRepository
    }
    
    func execute() -> [PHAsset] {
        photoRepository.fetchScreenShotPhotos()
    }
}
