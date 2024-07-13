//
//  LocalUserDataSource.swift
//  Particle
//
//  Created by 이원빈 on 2024/01/12.
//

import Foundation
import RxSwift
import CoreData

final class LocalUserDataSource {
    
    private let coreData: CoreDataStorage // coredata로 변경
    
    init(coreData: CoreDataStorage) {
        self.coreData = coreData
    }
}

extension LocalUserDataSource: UserDataSource {
    
    func getMyProfile() throws -> UserReadDTO {

        let arr = try coreData.persistentContainer.viewContext.fetch(CDUser.fetchRequest())
        guard let user = arr.last else {
            throw CoreDataError.dataIsNil
        } // 깔끔한 처리 필요
        return UserReadDTO(
            id: user.id ?? "NULL",
            nickname: user.nickName ?? "NULL",
            profileImageUrl: user.profileImageUrl ?? "NULL",
            interestedTags: user.interestedTags ?? [],
            interestedRecords: user.interestedRecords ?? []
        )
    }
    
    func setMyProfile(dto: UserReadDTO) throws {
        let managedContext = self.coreData.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "CDUser", in: managedContext)!
        let cdUser = NSManagedObject(entity: entity, insertInto: managedContext) as! CDUser
        
        cdUser.id = dto.id
        cdUser.nickName = dto.nickname
        cdUser.profileImageUrl = dto.profileImageUrl
        cdUser.interestedTags = dto.interestedTags
        cdUser.interestedRecords = dto.interestedRecords
        
        try managedContext.save()
    }
   
    func getInterestedTags() throws -> [String] {
        let arr = try coreData.persistentContainer.viewContext.fetch(CDUser.fetchRequest())
        let user = arr.last! // 깔끔한 처리 필요
        guard let tags = user.interestedTags else {
            throw CoreDataError.dataIsNil
        }
        return tags
    }
    
    func setInterestedTags(tags: [String]) throws {
        let arr = try coreData.persistentContainer.viewContext.fetch(CDUser.fetchRequest())
        let user = arr.last! // 깔끔한 처리 필요
        user.interestedTags = tags // # 처리 필요
        
        try coreData.persistentContainer.viewContext.save()
    }
    
    func addHeartToRecord(id: String) throws {
        let arr = try coreData.persistentContainer.viewContext.fetch(CDUser.fetchRequest())
        let user = arr.last! // 깔끔한 처리 필요
        guard var current = user.interestedRecords,
              current.contains(id) == false else { return }
        current.append(id)
        user.interestedRecords = current
        
        try coreData.persistentContainer.viewContext.save()
    }
    
    func deleteHeartFromRecord(id: String) throws {
        let arr = try coreData.persistentContainer.viewContext.fetch(CDUser.fetchRequest())
        let user = arr.last! // 깔끔한 처리 필요
        guard var current = user.interestedRecords,
              current.contains(id) == true else { return }
//        current = current.filter { $0 != id }
        user.interestedRecords = current.filter { $0 != id }
        
        try coreData.persistentContainer.viewContext.save()
    }
}

enum CoreDataError: LocalizedError {
    case dataIsNil
    
    var errorDescription: String? {
        switch self {
        case .dataIsNil: "코어데이터에 해당 속성값이 nil 입니다."
        }
    }
}
