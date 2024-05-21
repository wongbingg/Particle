//
//  AlbumManager.swift
//  Particle
//
//  Created by 이원빈 on 5/21/24.
//

import Photos
import RxSwift

struct AlbumManager {
    // 앨범 접근 권한 요청
    static func requestPhotoLibraryAccess() -> Observable<Bool> {
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
    
    // 앨범 목록 조회 (최근항목, 즐겨찾는 목록 제외)
    static func fetchUserAlbums() -> [String] {
        var albumTitles: [String] = []
        
        let userAlbums = PHAssetCollection.fetchAssetCollections(
            with: .album,
            subtype: .albumRegular,
            options: nil)
        
        userAlbums.enumerateObjects { collection, index, stop in
            if let title = collection.localizedTitle {
                albumTitles.append(title)
            }
        }
        return albumTitles
    }
    
    
    // 최근 항목 가져오기
    static func fetchRecentItems() -> Observable<PHFetchResult<PHAsset>> {
        
        return Observable.create { emitter in
            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            
            let recentItems = PHAssetCollection.fetchAssetCollections(
                with: .smartAlbum,
                subtype: .smartAlbumRecentlyAdded,
                options: fetchOptions)
            
            recentItems.enumerateObjects { (collection, index, stop) in
                let assets = PHAsset.fetchAssets(in: collection, options: nil)
                emitter.onNext(assets)
            }
            return Disposables.create()
        }
    }
    
    // 즐겨찾는 항목 가져오기
    static func fetchFavoriteItems() -> PHFetchResult<PHAsset> {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "favorite == YES")
        
        return PHAsset.fetchAssets(with: fetchOptions)
    }
}
