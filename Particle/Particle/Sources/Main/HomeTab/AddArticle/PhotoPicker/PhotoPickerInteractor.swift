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
    
    func setDataSource(data: [PHAsset])
    func setAlbumCategories(categories: [String])
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
    
    private let requestAlbumAccessUseCase: RequestAlbumAccessUseCase
    private let fetchAlbumListUseCase: FetchAlbumListUseCase
    private let fetchRecentAlbumUseCase: FetchRecentAlbumUseCase
    private let fetchFavoriteAlbumUseCase: FetchFavoriteAlbumUseCase
    private let fetchScreenshotAlbumUseCase: FetchScreenshotAlbumUseCase
    private let fetchKeywordAlbumUseCase: FetchKeywordAlbumUseCase
    private var disposeBag = DisposeBag()
    
    init(
        presenter: PhotoPickerPresentable,
        requestAlbumAccessUseCase: RequestAlbumAccessUseCase,
        fetchAlbumListUseCase: FetchAlbumListUseCase,
        fetchRecentAlbumUseCase: FetchRecentAlbumUseCase,
        fetchFavoriteAlbumUseCase: FetchFavoriteAlbumUseCase,
        fetchScreenshotAlbumUseCase: FetchScreenshotAlbumUseCase,
        fetchKeywordAlbumUseCase: FetchKeywordAlbumUseCase
    ) {
        self.requestAlbumAccessUseCase = requestAlbumAccessUseCase
        self.fetchAlbumListUseCase = fetchAlbumListUseCase
        self.fetchRecentAlbumUseCase = fetchRecentAlbumUseCase
        self.fetchFavoriteAlbumUseCase = fetchFavoriteAlbumUseCase
        self.fetchScreenshotAlbumUseCase = fetchScreenshotAlbumUseCase
        self.fetchKeywordAlbumUseCase = fetchKeywordAlbumUseCase
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        setup()
    }
    
    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func setup() {
        let categories = fetchAlbumListUseCase.execute()
        presenter.setAlbumCategories(categories: categories)
        requestAlbumAccessUseCase.execute()
            .observeOn(MainScheduler.instance)
            .subscribe { [weak self] isAllowed in
                isAllowed ? self?.switchCategory(to: "최근 항목") : Console.debug("앨범 접근권한 필요")
            } onError: { error in
                Console.error(error.localizedDescription)
            }
            .disposed(by: disposeBag)

    }
    
    // MARK: - PhotoPickerListener
    
    func cancelButtonTapped() {
        listener?.cancelButtonTapped()
    }
    
    func nextButtonTapped(with assets: [PHAsset]) {
        listener?.nextButtonTapped(with: assets)
    }
    
    func switchCategory(to category: String) {
        switch category {
        case "최근 항목":
            fetchRecentAlbumUseCase.execute()
                .observeOn(MainScheduler.instance)
                .subscribe { [weak self] result in
                    self?.presenter.setDataSource(data: result)
                } onError: { error in
                    Console.error(error.localizedDescription)
                }
                .disposed(by: disposeBag)
        case "즐겨찾는 항목":
            let result = fetchFavoriteAlbumUseCase.execute()
            self.presenter.setDataSource(data: result)
        case "스크린샷":
            let result = fetchScreenshotAlbumUseCase.execute()
            self.presenter.setDataSource(data: result)
        default:
            fetchKeywordAlbumUseCase.execute(keyword: category)
                .observeOn(MainScheduler.instance)
                .subscribe { [weak self] result in
                    self?.presenter.setDataSource(data: result)
                } onError: { error in
                    Console.error(error.localizedDescription)
                }
                .disposed(by: disposeBag)
        }
    }
}
