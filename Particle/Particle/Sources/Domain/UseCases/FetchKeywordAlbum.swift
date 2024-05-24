//
//  FetchKeywordAlbum.swift
//  Particle
//
//  Created by 이원빈 on 5/24/24.
//

import RxSwift
import Photos

protocol FetchKeywordAlbum {
    func execute(keyword: String) -> Observable<[PHAsset]>
}

final class DefaultFetchKeywordAlbum: FetchKeywordAlbum {
    private let photoRepository: PhotoRepository
    
    init(photoRepository: PhotoRepository) {
        self.photoRepository = photoRepository
    }
    
    func execute(keyword: String) -> Observable<[PHAsset]> {
        photoRepository.fetchPhotosBy(keyword: keyword)
    }
}
