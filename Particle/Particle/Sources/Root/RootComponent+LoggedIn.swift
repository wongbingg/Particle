//
//  RootComponent+LoggedIn.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/10.
//

import RIBs

protocol RootDependencyLoggedIn: Dependency {
    
}

extension RootComponent: LoggedInDependency {
    
    var loggedInViewController: LoggedInViewControllable {
        return rootViewController
    }
}
