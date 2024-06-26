//
//  PhotoRepository.swift
//  Particle
//
//  Created by 이원빈 on 5/24/24.
//

import Foundation
import RxSwift
import Photos

protocol PhotoRepository {
    func requestAuthorization() -> Observable<Bool>
    func fetchAlbumList() -> [String]
    func fetchRecentPhotos() -> Observable<[PHAsset]>
    func fetchFavoritePhotos() -> [PHAsset]
    func fetchScreenShotPhotos() -> [PHAsset]
    func fetchPhotosBy(keyword: String) -> Observable<[PHAsset]>
}
