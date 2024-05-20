//
//  SetAccountBuilder.swift
//  Particle
//
//  Created by 이원빈 on 2023/09/07.
//

import RIBs

protocol SetAccountDependency: Dependency {
    var authService: AuthService { get }
}

final class SetAccountComponent: Component<SetAccountDependency> {
    fileprivate var withdrawUseCase: WithdrawUseCase {
        DefaultWithdrawUseCase(authService: dependency.authService)
    }
}

// MARK: - Builder

protocol SetAccountBuildable: Buildable {
    func build(withListener listener: SetAccountListener) -> SetAccountRouting
}

final class SetAccountBuilder: Builder<SetAccountDependency>, SetAccountBuildable {

    override init(dependency: SetAccountDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: SetAccountListener) -> SetAccountRouting {
        let component = SetAccountComponent(dependency: dependency)
        let viewController = SetAccountViewController()
        let interactor = SetAccountInteractor(
            presenter: viewController,
            withdrawUseCase: component.withdrawUseCase
        )
        interactor.listener = listener
        return SetAccountRouter(interactor: interactor, viewController: viewController)
    }
}
