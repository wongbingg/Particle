//
//  MyPageBuilder.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/18.
//

import RIBs

protocol MyPageDependency: Dependency {
    var userRepository: UserRepository { get }
    var authService: AuthService { get }
}

final class MyPageComponent: Component<MyPageDependency>,
                             SetAccountDependency,
                             SetAlarmDependency,
                             SetInterestedTagsDependency {
    
    var userRepository: UserRepository {
        return dependency.userRepository
    }
    
    var authService: AuthService {
        return dependency.authService
    }
    
    fileprivate var fetchMyProfileUseCase: FetchMyProfileUseCase {
        return DefaultFetchMyProfileUseCase(userRepository: userRepository)
    }
}

// MARK: - Builder

protocol MyPageBuildable: Buildable {
    func build(withListener listener: MyPageListener) -> MyPageRouting
}

final class MyPageBuilder: Builder<MyPageDependency>, MyPageBuildable {
    
    override init(dependency: MyPageDependency) {
        super.init(dependency: dependency)
    }
    
    func build(withListener listener: MyPageListener) -> MyPageRouting {
        let component = MyPageComponent(dependency: dependency)
        let viewController = MyPageViewController()
        let interactor = MyPageInteractor(
            presenter: viewController,
            fetchMyProfileUseCase: component.fetchMyProfileUseCase
        )
        interactor.listener = listener
        
        let setAccountBuildable = SetAccountBuilder(dependency: component)
        let setAlarmBuildable = SetAlarmBuilder(dependency: component)
        let setInterestedTagsBuildable = SetInterestedTagsBuilder(dependency: component)
        
        return MyPageRouter(
            interactor: interactor,
            viewController: viewController,
            setAccountBuildable: setAccountBuildable,
            setAlarmBuildable: setAlarmBuildable,
            setInterestedTagsBuildable: setInterestedTagsBuildable
        )
    }
}
