//
//  DefaultUserRepository.swift
//  Particle
//
//  Created by 이원빈 on 2023/10/10.
//

import Foundation
import RxSwift

final class DefaultUserRepository: UserRepository {
    
    private let userDataSource: UserDataSource
    
    init(userDataSource: UserDataSource) {
        self.userDataSource = userDataSource
    }
    
    func getMyProfile() -> RxSwift.Observable<UserReadDTO> {
        return userDataSource.getMyProfile()
    }
    
    func setInterestedTags(tags: [String]) -> RxSwift.Observable<UserReadDTO> {
        return userDataSource.setInterestedTags(tags: tags)
    }
    
    func getInterestedTags() -> Observable<[String]> {
        guard let tags = UserDefaults.standard.stringArray(forKey: "INTERESTED_TAGS") else { return Observable.just([])
        }
        return Observable.just(tags)
    }
}
