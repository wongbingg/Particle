//
//  RootBuilder.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/10.
//

import RIBs

protocol RootDependency: Dependency {
    var authService: AuthService { get }
    var userRepository: UserRepository { get }
}

final class RootComponent: Component<RootDependency> {

    let rootViewController: RootViewController
    
    init(
        dependency: RootDependency,
        rootViewController: RootViewController
    ) {
        self.rootViewController = rootViewController
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol RootBuildable: Buildable {
    func build() -> LaunchRouting
}

final class RootBuilder: Builder<RootDependency>, RootBuildable {
    
    override init(dependency: RootDependency) {
        super.init(dependency: dependency)
    }

    func build() -> LaunchRouting {
        let rootViewController = RootViewController()
        let component = RootComponent(
            dependency: dependency,
            rootViewController: rootViewController
        )
        let interactor = RootInteractor(presenter: rootViewController)
        
        let loggedOutBuilder = LoggedOutBuilder(dependency: component)
        let loggedInBuilder = LoggedInBuilder(dependency: component)
        
        return RootRouter(
            interactor: interactor,
            viewController: rootViewController,
            loggedOutBuilder: loggedOutBuilder,
            loggedInBuilder: loggedInBuilder
        )
    }
}
