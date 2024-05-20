//
//  SetInterestedTagsUseCase.swift
//  Particle
//
//  Created by 이원빈 on 2023/10/12.
//

import Foundation
import RxSwift

protocol SetInterestedTagsUseCase {
    func execute(tags: [String]) -> Observable<Bool>
}

final class DefaultSetInterestedTagsUseCase: SetInterestedTagsUseCase {
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func execute(tags: [String]) -> Observable<Bool> {
        userRepository.setInterestedTags(tags: tags)
            .map { dto in
                UserDefaults.standard.set(dto.interestedTags.map { "#\($0)" }, forKey: "INTERESTED_TAGS")
                return true
            }
//            .catchAndReturn(false)
    }
}
