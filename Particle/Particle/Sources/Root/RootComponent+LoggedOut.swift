//
//  RootComponent+LoggedOut.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/10.
//

import RIBs

protocol RootDependencyLoggedOut: Dependency {
    
}

extension RootComponent: LoggedOutDependency {
    
    var loginUseCase: LoginUseCase {
        return DefaultLoginUseCase(authService: dependency.authService)
    }
    
    var setInterestedTagsUseCase: SetInterestedTagsUseCase {
        return DefaultSetInterestedTagsUseCase(userRepository: dependency.userRepository)
    }
}
