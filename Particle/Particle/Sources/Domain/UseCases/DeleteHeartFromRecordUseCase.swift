//
//  DeleteHeartFromRecordUseCase.swift
//  Particle
//
//  Created by 이원빈 on 7/13/24.
//

protocol DeleteHeartFromRecordUseCase {
    func execute(id: String) throws
}

final class DefaultDeleteHeartFromRecordUseCase: DeleteHeartFromRecordUseCase {
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func execute(id: String) throws {
        try userRepository.deleteHeartFromRecord(id: id)
    }
}
