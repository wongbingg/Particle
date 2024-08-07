//
//  FetchMyProfileUseCase.swift
//  Particle
//
//  Created by 이원빈 on 2023/10/15.
//

import RxSwift

protocol FetchMyProfileUseCase {
    func execute() throws -> UserReadDTO
}

final class DefaultFetchMyProfileUseCase: FetchMyProfileUseCase {
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func execute() throws -> UserReadDTO {
        try userRepository.getMyProfile()
    }
}
