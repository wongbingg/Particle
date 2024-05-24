//
//  FetchKeywordAlbumUseCase.swift
//  Particle
//
//  Created by 이원빈 on 5/24/24.
//

import RxSwift
import Photos

protocol FetchKeywordAlbumUseCase {
    func execute(keyword: String) -> Observable<[PHAsset]>
}

final class DefaultFetchKeywordAlbumUseCase: FetchKeywordAlbumUseCase {
    private let photoRepository: PhotoRepository
    
    init(photoRepository: PhotoRepository) {
        self.photoRepository = photoRepository
    }
    
    func execute(keyword: String) -> Observable<[PHAsset]> {
        photoRepository.fetchPhotosBy(keyword: keyword)
    }
}
