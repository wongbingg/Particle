//
//  ExploreBuilder.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/18.
//

import RIBs

protocol ExploreDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class ExploreComponent: Component<ExploreDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol ExploreBuildable: Buildable {
    func build(withListener listener: ExploreListener) -> ExploreRouting
}

final class ExploreBuilder: Builder<ExploreDependency>, ExploreBuildable {

    override init(dependency: ExploreDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: ExploreListener) -> ExploreRouting {
        let _ = ExploreComponent(dependency: dependency)
        let viewController = ExploreViewController()
        let interactor = ExploreInteractor(presenter: viewController)
        interactor.listener = listener
        return ExploreRouter(interactor: interactor, viewController: viewController)
    }
}
