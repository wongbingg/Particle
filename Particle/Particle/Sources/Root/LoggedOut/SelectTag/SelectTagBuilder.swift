//
//  SelectTagBuilder.swift
//  Particle
//
//  Created by 이원빈 on 2023/08/24.
//

import RIBs

protocol SelectTagDependency: Dependency {
    var setInterestedTagsUseCase: SetInterestedTagsUseCase { get }
}

final class SelectTagComponent: Component<SelectTagDependency> {
    
    fileprivate var setInterestedTagsUseCase: SetInterestedTagsUseCase {
        dependency.setInterestedTagsUseCase
    }
}

// MARK: - Builder

protocol SelectTagBuildable: Buildable {
    func build(withListener listener: SelectTagListener) -> SelectTagRouting
}

final class SelectTagBuilder: Builder<SelectTagDependency>, SelectTagBuildable {

    override init(dependency: SelectTagDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: SelectTagListener) -> SelectTagRouting {
        let component = SelectTagComponent(dependency: dependency)
        let viewController = SelectTagViewController()
        let interactor = SelectTagInteractor(
            presenter: viewController,
            setInterestedTagsUseCase: component.setInterestedTagsUseCase
        )
        interactor.listener = listener
        return SelectTagRouter(interactor: interactor, viewController: viewController)
    }
}
