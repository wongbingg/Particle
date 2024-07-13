//
//  SetInterestedTagsUseCase.swift
//  Particle
//
//  Created by 이원빈 on 2023/10/12.
//

import Foundation
import RxSwift

protocol SetInterestedTagsUseCase {
    func execute(tags: [String]) throws
}

final class DefaultSetInterestedTagsUseCase: SetInterestedTagsUseCase {
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func execute(tags: [String]) throws {
        try userRepository.setInterestedTags(tags: tags)
    }
}
