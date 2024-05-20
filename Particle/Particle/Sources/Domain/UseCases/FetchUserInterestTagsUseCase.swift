//
//  FetchUserInterestTagsUseCase.swift
//  Particle
//
//  Created by 홍석현 on 12/12/23.
//

import Foundation
import RxSwift

protocol FetchUserInterestTagsUseCase {
    func execute() -> Observable<[String]>
}

struct DefaultFetchUserInterestTagsUseCase: FetchUserInterestTagsUseCase {
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func execute() -> Observable<[String]> {
        userRepository.getInterestedTags()
    }
}
