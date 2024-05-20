//
//  OrganizingSentenceBuilder.swift
//  Particle
//
//  Created by Sh Hong on 2023/07/11.
//

import RIBs

protocol OrganizingSentenceDependency: Dependency {
    var organizingSentenceRepository: OrganizingSentenceRepository { get }
}

final class OrganizingSentenceComponent: Component<OrganizingSentenceDependency> {
    var organizingSentenceRepository: OrganizingSentenceRepository {
        dependency.organizingSentenceRepository
    }
}

// MARK: - Builder

protocol OrganizingSentenceBuildable: Buildable {
    func build(withListener listener: OrganizingSentenceListener) -> OrganizingSentenceRouting
}

final class OrganizingSentenceBuilder: Builder<OrganizingSentenceDependency>, OrganizingSentenceBuildable {
    
    override init(dependency: OrganizingSentenceDependency) {
        super.init(dependency: dependency)
    }
    
    func build(withListener listener: OrganizingSentenceListener) -> OrganizingSentenceRouting {
        let component = OrganizingSentenceComponent(dependency: dependency)
        let viewController = OrganizingSentenceViewController()
        let interactor = OrganizingSentenceInteractor(
            presenter: viewController,
            dependency: component.organizingSentenceRepository
        )
        interactor.listener = listener
        return OrganizingSentenceRouter(
            interactor: interactor,
            viewController: viewController
        )
    }
}
