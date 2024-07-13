//
//  SetMyProfileUseCase.swift
//  Particle
//
//  Created by 이원빈 on 7/13/24.
//

protocol SetMyProfileUseCase {
    func execute(dto: UserReadDTO) throws
}

final class DefaultSetMyProfileUseCase: SetMyProfileUseCase {
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func execute(dto: UserReadDTO) throws {
        try userRepository.setMyProfile(dto: dto)
    }
}
