//
//  SetAlarmBuilder.swift
//  Particle
//
//  Created by 이원빈 on 2023/09/07.
//

import RIBs

protocol SetAlarmDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class SetAlarmComponent: Component<SetAlarmDependency>, DirectlySetAlarmDependency {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol SetAlarmBuildable: Buildable {
    func build(withListener listener: SetAlarmListener) -> SetAlarmRouting
}

final class SetAlarmBuilder: Builder<SetAlarmDependency>, SetAlarmBuildable {

    override init(dependency: SetAlarmDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: SetAlarmListener) -> SetAlarmRouting {
        let component = SetAlarmComponent(dependency: dependency)
        let viewController = SetAlarmViewController()
        let interactor = SetAlarmInteractor(presenter: viewController)
        interactor.listener = listener
        
        let directlySetAlarmBuildable = DirectlySetAlarmBuilder(dependency: component)
        
        return SetAlarmRouter(
            interactor: interactor,
            viewController: viewController,
            directlySetAlarmBuildable: directlySetAlarmBuildable
        )
    }
}
