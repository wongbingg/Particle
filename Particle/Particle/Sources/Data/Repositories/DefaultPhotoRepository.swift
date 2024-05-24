//
//  DefaultPhotoRepository.swift
//  Particle
//
//  Created by 이원빈 on 5/24/24.
//

import Foundation
import RxSwift
import Photos

struct DefaultPhotoRepository: PhotoRepository {
    
    func requestAuthorization() -> Observable<Bool> {
        return Observable.create { emitter in
            let status = PHPhotoLibrary.authorizationStatus()
            switch status {
            case .authorized:
                emitter.onNext(true)
            case .denied, .restricted, .limited:
                emitter.onNext(false)
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization { newStatus in
                    emitter.onNext(newStatus == .authorized)
                }
            @unknown default:
                emitter.onNext(false)
            }
            return Disposables.create()
        }
    }
    
    func fetchRecentPhotos() -> Observable<[PHAsset]> {
        return Observable.create { emitter in
            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            
            let recentItems = PHAssetCollection.fetchAssetCollections(
                with: .album,
                subtype: .albumRegular,
                options: fetchOptions)
            
            recentItems.enumerateObjects { (collection, index, stop) in
                let assets = PHAsset.fetchAssets(in: collection, options: nil)
                var targetList = [PHAsset]()
                assets.enumerateObjects { asset, index, stop in
                    targetList.append(asset)
                }
                emitter.onNext(targetList)
            }
            return Disposables.create()
        }
    }
    
    func fetchFavoritePhotos() -> [PHAsset] {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "favorite == YES")
        
        let result = PHAsset.fetchAssets(with: fetchOptions)
        var targetList = [PHAsset]()
        result.enumerateObjects { asset, index, stop in
            targetList.append(asset)
        }
        return targetList
    }
    
    func fetchPhotosBy(keyword: String) -> Observable<[PHAsset]> {
        return Observable.create { emitter in
            // 사용자 앨범을 가져옴
            let userAlbums = PHAssetCollection.fetchAssetCollections(
                with: .album,
                subtype: .albumRegular,
                options: nil)
            
            // 앨범을 순회하면서 제목이 일치하는 앨범을 찾음
            var targetAlbum: PHAssetCollection?
            userAlbums.enumerateObjects { (collection, _, stop) in
                if collection.localizedTitle == keyword {
                    targetAlbum = collection
                    stop.pointee = true
                }
            }
            
            // 일치하는 앨범을 찾았다면 해당 앨범의 사진을 가져옴
            if let album = targetAlbum {
                let assets = PHAsset.fetchAssets(in: album, options: nil)
                var assetArray: [PHAsset] = []
                assets.enumerateObjects { (asset, _, _) in
                    assetArray.append(asset)
                }
                emitter.onNext(assetArray)
            } else {
                // 일치하는 앨범을 찾지 못한 경우
                emitter.onNext([])
            }
            return Disposables.create()
        }
    }
}
