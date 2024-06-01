//
//  PhotoPickerBuilder.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/19.
//

import RIBs

protocol PhotoPickerDependency: Dependency {
    var photoRepository: PhotoRepository { get }
}

final class PhotoPickerComponent: Component<PhotoPickerDependency> {
    let requestAlbumAccessUseCase: RequestAlbumAccessUseCase
    let fetchAlbumListUseCase: FetchAlbumListUseCase
    let fetchRecentAlbumUseCase: FetchRecentAlbumUseCase
    let fetchFavoriteAlbumUseCase: FetchFavoriteAlbumUseCase
    let fetchKeywordAlbumUseCase: FetchKeywordAlbumUseCase
    let fetchScreenshotAlbumUseCase: FetchScreenshotAlbumUseCase
    
    override init(dependency: PhotoPickerDependency) {
        self.requestAlbumAccessUseCase = DefaultRequestAlbumAccessUseCase(
            photoRepository: dependency.photoRepository
        )
        self.fetchAlbumListUseCase = DefaultFetchAlbumListUseCase(
            photoRepository: dependency.photoRepository
        )
        self.fetchRecentAlbumUseCase = DefaultFetchRecentAlbumUseCase(
            photoRepository: dependency.photoRepository
        )
        self.fetchFavoriteAlbumUseCase = DefaultFetchFavoriteAlbumUseCase(
            photoRepository: dependency.photoRepository
        )
        self.fetchKeywordAlbumUseCase = DefaultFetchKeywordAlbumUseCase(
            photoRepository: dependency.photoRepository
        )
        self.fetchScreenshotAlbumUseCase = DefaultFetchScreenshotAlbumUseCase(
            photoRepository: dependency.photoRepository
        )
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol PhotoPickerBuildable: Buildable {
    func build(withListener listener: PhotoPickerListener) -> PhotoPickerRouting
}

final class PhotoPickerBuilder: Builder<PhotoPickerDependency>, PhotoPickerBuildable {

    override init(dependency: PhotoPickerDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: PhotoPickerListener) -> PhotoPickerRouting {
        let component = PhotoPickerComponent(dependency: dependency)
        let viewController = PhotoPickerViewController()
        let interactor = PhotoPickerInteractor(
            presenter: viewController,
            requestAlbumAccessUseCase: component.requestAlbumAccessUseCase,
            fetchAlbumListUseCase: component.fetchAlbumListUseCase,
            fetchRecentAlbumUseCase: component.fetchRecentAlbumUseCase,
            fetchFavoriteAlbumUseCase: component.fetchFavoriteAlbumUseCase,
            fetchScreenshotAlbumUseCase: component.fetchScreenshotAlbumUseCase,
            fetchKeywordAlbumUseCase: component.fetchKeywordAlbumUseCase)
        interactor.listener = listener
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.systemEventHandler = interactor
        }
        return PhotoPickerRouter(interactor: interactor, viewController: viewController)
    }
}
