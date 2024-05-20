//
//  UserDataSource.swift
//  Particle
//
//  Created by 이원빈 on 2023/10/10.
//

import RxSwift

protocol UserDataSource {
    func getMyProfile() -> Observable<UserReadDTO>
    func setInterestedTags(tags: [String]) -> Observable<UserReadDTO>
}
