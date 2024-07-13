//
//  UserSingleton.swift
//  Particle
//
//  Created by 이원빈 on 7/13/24.
//

import Foundation

final class UserSingleton {
    static let shared = UserSingleton()
    private let userRepository: UserRepository

    var info: UserReadDTO? {
        do {
            return try userRepository.getMyProfile()
        } catch {
            Console.error(error.localizedDescription)
            return nil
        }
    }
    
    private init() {
        let userDataSource = LocalUserDataSource(coreData: .shared)
        self.userRepository = DefaultUserRepository(userDataSource: userDataSource)
    }
}
