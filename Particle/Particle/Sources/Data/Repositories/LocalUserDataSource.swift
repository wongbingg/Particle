//
//  LocalUserDataSource.swift
//  Particle
//
//  Created by 이원빈 on 2024/01/12.
//

import Foundation
import RxSwift

final class LocalUserDataSource: UserDataSource {
    
    private let coreData: CoreDataStorage // coredata로 변경
    
    init(coreData: CoreDataStorage) {
        self.coreData = coreData
    }
}

extension LocalUserDataSource {
    
    func getMyProfile() -> RxSwift.Observable<UserReadDTO> {

        return Observable.create { [weak self] emitter in
            do {
                let arr = try self?.coreData.persistentContainer.viewContext.fetch(CDUser.fetchRequest())
                let user = arr!.last! // 깔끔한 처리 필요
                emitter.onNext(
                    .init(
                        id: user.id ?? "",
                        nickname: user.nickName ?? "",
                        profileImageUrl: user.profileImageUrl ?? "",
                        interestedTags: user.interestedTags ?? []
                    )
                )
            } catch {
                emitter.onError(error)
            }
            return Disposables.create()
        }
    }
    
    func setInterestedTags(tags: [String]) -> RxSwift.Observable<UserReadDTO> {
        
        return Observable.create { [weak self] emitter in
            do {
                let arr = try self?.coreData.persistentContainer.viewContext.fetch(CDUser.fetchRequest())
                let user = arr!.last! // 깔끔한 처리 필요
                user.interestedTags = tags // # 처리 필요
                try self?.coreData.persistentContainer.viewContext.save()
                emitter.onNext(
                    .init(
                        id: user.id ?? "",
                        nickname: user.nickName ?? "",
                        profileImageUrl: user.profileImageUrl ?? "",
                        interestedTags: user.interestedTags ?? []
                    )
                )
            } catch {
                emitter.onError(error)
            }
            return Disposables.create()
        }
    }
}
