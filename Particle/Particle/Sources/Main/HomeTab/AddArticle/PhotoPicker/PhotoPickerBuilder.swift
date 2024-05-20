//
//  PhotoPickerBuilder.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/19.
//

import RIBs

protocol PhotoPickerDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class PhotoPickerComponent: Component<PhotoPickerDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
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
        let _ = PhotoPickerComponent(dependency: dependency)
        let viewController = PhotoPickerViewController()
        let interactor = PhotoPickerInteractor(presenter: viewController)
        interactor.listener = listener
        return PhotoPickerRouter(interactor: interactor, viewController: viewController)
    }
}
