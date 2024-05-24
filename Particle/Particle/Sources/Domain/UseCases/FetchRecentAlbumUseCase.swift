//
//  FetchRecentAlbumUseCase.swift
//  Particle
//
//  Created by 이원빈 on 5/24/24.
//

import RxSwift
import Photos

protocol FetchRecentAlbumUseCase {
    func execute() -> Observable<[PHAsset]>
}

final class DefaultFetchRecentAlbumUseCase: FetchRecentAlbumUseCase {
    private let photoRepository: PhotoRepository
    
    init(photoRepository: PhotoRepository) {
        self.photoRepository = photoRepository
    }
    
    func execute() -> Observable<[PHAsset]> {
        photoRepository.fetchRecentPhotos()
    }
}
