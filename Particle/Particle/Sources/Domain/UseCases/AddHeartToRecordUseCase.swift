//
//  AddHeartToRecordUseCase.swift
//  Particle
//
//  Created by 이원빈 on 7/13/24.
//

protocol AddHeartToRecordUseCase {
    func execute(id: String) throws
}

final class DefaultAddHeartToRecordUseCase: AddHeartToRecordUseCase {
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func execute(id: String) throws {
        try userRepository.addHeartToRecord(id: id)
    }
}
