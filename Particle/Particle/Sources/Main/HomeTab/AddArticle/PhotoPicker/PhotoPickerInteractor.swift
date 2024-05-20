//
//  PhotoPickerInteractor.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/19.
//

import RIBs
import RxSwift
import Photos

protocol PhotoPickerRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol PhotoPickerPresentable: Presentable {
    var listener: PhotoPickerPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol PhotoPickerListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
    func cancelButtonTapped()
    func nextButtonTapped(with images: [PHAsset])
}

final class PhotoPickerInteractor: PresentableInteractor<PhotoPickerPresentable>,
                                   PhotoPickerInteractable,
                                   PhotoPickerPresentableListener {
    
    weak var router: PhotoPickerRouting?
    weak var listener: PhotoPickerListener?
    
    private(set) var allPhotos: PHFetchResult<PHAsset>? = nil // 앨범에서 사진을 가져오는 Repository 따로 구현 필요 ,
    private(set) var photoCount = Int()
    
    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: PhotoPickerPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        
        // TODO: allPhotos 불러오기
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false, selector: nil)]

        self.allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        photoCount = self.allPhotos?.count ?? 0
    }
    
    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    // MARK: - PhotoPickerListener
    
    func cancelButtonTapped() {
        listener?.cancelButtonTapped()
    }
    
    func nextButtonTapped(with indexes: [Int]) {
        listener?.nextButtonTapped(with: getSelectedPhotos(from: indexes))
    }
    
    private func getSelectedPhotos(from indexes: [Int]) -> [PHAsset] {
        guard let allPhotos = allPhotos else {
            Console.error("\(#function) allPhotos 값이 존재하지 않습니다.")
            return []
        }
        let selectedPhotos = indexes.map {
            allPhotos.object(at: $0)
        }
        
        return selectedPhotos
    }
    
    func fetchAllPhotos() -> PHFetchResult<PHAsset> {
        return allPhotos ?? .init()
    }
    
    func fetchAllPhotosCount() -> Int {
        return photoCount
    }
    
}
