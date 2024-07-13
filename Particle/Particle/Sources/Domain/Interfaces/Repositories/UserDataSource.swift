//
//  UserDataSource.swift
//  Particle
//
//  Created by 이원빈 on 2023/10/10.
//

import RxSwift

protocol UserDataSource {
    func setMyProfile(dto: UserReadDTO) throws
    func getMyProfile() throws -> UserReadDTO
    func setInterestedTags(tags: [String]) throws
    func getInterestedTags() throws -> [String]
    func addHeartToRecord(id: String) throws
    func deleteHeartFromRecord(id: String) throws
}
