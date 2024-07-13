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
    
    func getMyProfile() throws -> UserReadDTO {
        return try userDataSource.getMyProfile()
    }
    
    func setMyProfile(dto: UserReadDTO) throws {
        try self.userDataSource.setMyProfile(dto: dto)
    }
    
    func getInterestedTags() throws -> [String] {
        return try userDataSource.getInterestedTags()
    }
    
    func setInterestedTags(tags: [String]) throws {
        try self.userDataSource.setInterestedTags(tags: tags)
    }
    
    func addHeartToRecord(id: String) throws {
        try self.userDataSource.addHeartToRecord(id: id)
    }
    
    func deleteHeartFromRecord(id: String) throws {
        try self.userDataSource.deleteHeartFromRecord(id: id)
    }
    
    
}
