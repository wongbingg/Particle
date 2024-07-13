//
//  UserRepository.swift
//  Particle
//
//  Created by 이원빈 on 2023/10/10.
//

import RxSwift

protocol UserRepository {
    func getMyProfile() throws -> UserReadDTO
    func setMyProfile(dto: UserReadDTO) throws
    func getInterestedTags() throws -> [String]
    func setInterestedTags(tags: [String]) throws
    func addHeartToRecord(id: String) throws
    func deleteHeartFromRecord(id: String) throws
}
