//
//  SelectSentenceBuilder.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/13.
//

import RIBs
import Photos

protocol SelectSentenceDependency: Dependency {
    var organizingSentenceRepository: OrganizingSentenceRepository { get }
}

final class SelectSentenceComponent: Component<SelectSentenceDependency> {
    fileprivate var organizingSentenceRepository: OrganizingSentenceRepository {
        return dependency.organizingSentenceRepository
    }
}

// MARK: - Builder

protocol SelectSentenceBuildable: Buildable {
    func build(withListener listener: SelectSentenceListener, images: [PHAsset]) -> SelectSentenceRouting
}

final class SelectSentenceBuilder: Builder<SelectSentenceDependency>, SelectSentenceBuildable {

    override init(dependency: SelectSentenceDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: SelectSentenceListener, images: [PHAsset]) -> SelectSentenceRouting {
        let component = SelectSentenceComponent(dependency: dependency)
        let viewController = SelectSentenceViewController(selectedImages: images)
        let interactor = SelectSentenceInteractor(
            presenter: viewController,
            repository: component.organizingSentenceRepository
        )
        interactor.listener = listener
        
        let editSentenceBuilder = EditSentenceBuilder(dependency: component)
        
        return SelectSentenceRouter(
            interactor: interactor,
            viewController: viewController,
            editSentenceBuilder: editSentenceBuilder
        )
    }
}

extension SelectSentenceComponent: EditSentenceDependency { }
