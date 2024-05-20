//
//  AppComponent.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/10.
//

import RIBs

class AppComponent: Component<EmptyComponent>, RootDependency {
    var authService: AuthService
    var userRepository: UserRepository
    
    init() {
        
        let config = ApiDataNetworkConfig(
            baseURL: URL(string: ParticleServer.baseURL) ?? .applicationDirectory,
            headers: [
                "Content-Type": "application/json"
            ]
        )
        let networkService = DefaultNetworkService(config: config)
        let dataTransferService = DefaultDataTransferService(with: networkService)
        
        self.authService = DefaultAuthService(dataTransferService: dataTransferService)
        
        let userDataSource = DefaultUserDataSource(dataTransferService: dataTransferService)
        self.userRepository = DefaultUserRepository(userDataSource: userDataSource)
        
        super.init(dependency: EmptyComponent())
    }
}
