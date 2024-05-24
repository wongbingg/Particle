//
//  RequestAlbumAccessUseCase.swift
//  Particle
//
//  Created by 이원빈 on 5/24/24.
//

import Foundation
import RxSwift

protocol RequestAlbumAccessUseCase {
    func execute() -> Observable<Bool>
}

final class DefaultRequestAlbumAccessUseCase: RequestAlbumAccessUseCase {
    private let photoRepository: PhotoRepository
    
    init(photoRepository: PhotoRepository) {
        self.photoRepository = photoRepository
    }
    
    func execute() -> Observable<Bool> {
        photoRepository.requestAuthorization()
    }
}
