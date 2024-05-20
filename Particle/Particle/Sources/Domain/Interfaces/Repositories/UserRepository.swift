//
//  UserRepository.swift
//  Particle
//
//  Created by 이원빈 on 2023/10/10.
//

import RxSwift

protocol UserRepository {
    func getMyProfile() -> Observable<UserReadDTO>
    func setInterestedTags(tags: [String]) -> Observable<UserReadDTO>
    func getInterestedTags() -> Observable<[String]>
}
