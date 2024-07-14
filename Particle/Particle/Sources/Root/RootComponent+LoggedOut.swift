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
    var fetchMyProfileUseCase: FetchMyProfileUseCase {
        return DefaultFetchMyProfileUseCase(userRepository: dependency.userRepository)
    }
    
    var setMyProfileUseCase: SetMyProfileUseCase {
        return DefaultSetMyProfileUseCase(userRepository: dependency.userRepository)
    }
    
    var setInterestedTagsUseCase: SetInterestedTagsUseCase {
        return DefaultSetInterestedTagsUseCase(userRepository: dependency.userRepository)
    }
}
