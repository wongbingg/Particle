//
//  DirectlySetAlarmBuilder.swift
//  Particle
//
//  Created by 이원빈 on 2023/09/07.
//

import RIBs

protocol DirectlySetAlarmDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class DirectlySetAlarmComponent: Component<DirectlySetAlarmDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol DirectlySetAlarmBuildable: Buildable {
    func build(withListener listener: DirectlySetAlarmListener) -> DirectlySetAlarmRouting
}

final class DirectlySetAlarmBuilder: Builder<DirectlySetAlarmDependency>, DirectlySetAlarmBuildable {

    override init(dependency: DirectlySetAlarmDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: DirectlySetAlarmListener) -> DirectlySetAlarmRouting {
        let component = DirectlySetAlarmComponent(dependency: dependency)
        let viewController = DirectlySetAlarmViewController()
        let interactor = DirectlySetAlarmInteractor(presenter: viewController)
        interactor.listener = listener
        return DirectlySetAlarmRouter(interactor: interactor, viewController: viewController)
    }
}
