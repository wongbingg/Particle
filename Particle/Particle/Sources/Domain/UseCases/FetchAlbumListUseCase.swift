//
//  FetchAlbumListUseCase.swift
//  Particle
//
//  Created by 이원빈 on 5/24/24.
//

import RxSwift

protocol FetchAlbumListUseCase {
    func execute() -> [String]
}

final class DefaultFetchAlbumListUseCase: FetchAlbumListUseCase {
    private let photoRepository: PhotoRepository
    
    init(photoRepository: PhotoRepository) {
        self.photoRepository = photoRepository
    }
    
    func execute() -> [String] {
        photoRepository.fetchAlbumList()
    }
}
