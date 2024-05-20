//
//  SetInterestedTagsBuilder.swift
//  Particle
//
//  Created by 이원빈 on 2023/09/10.
//

import RIBs

protocol SetInterestedTagsDependency: Dependency {
    var userRepository: UserRepository { get }
}

final class SetInterestedTagsComponent: Component<SetInterestedTagsDependency> {

    fileprivate var setInterestedTagsUseCase: SetInterestedTagsUseCase {
        return DefaultSetInterestedTagsUseCase(userRepository: dependency.userRepository)
    }
}

// MARK: - Builder

protocol SetInterestedTagsBuildable: Buildable {
    func build(withListener listener: SetInterestedTagsListener) -> SetInterestedTagsRouting
}

final class SetInterestedTagsBuilder: Builder<SetInterestedTagsDependency>, SetInterestedTagsBuildable {

    override init(dependency: SetInterestedTagsDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: SetInterestedTagsListener) -> SetInterestedTagsRouting {
        let component = SetInterestedTagsComponent(dependency: dependency)
        let viewController = SetInterestedTagsViewController()
        let interactor = SetInterestedTagsInteractor(
            presenter: viewController,
            setInterestedTagsUseCase: component.setInterestedTagsUseCase
        )
        interactor.listener = listener
        return SetInterestedTagsRouter(interactor: interactor, viewController: viewController)
    }
}
