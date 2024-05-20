//
//  DefaultUserDataSource.swift
//  Particle
//
//  Created by 이원빈 on 2023/10/10.
//

import Foundation
import RxSwift

final class DefaultUserDataSource: UserDataSource {
    
    private let dataTransferService: DataTransferService
    
    init(dataTransferService: DataTransferService) {
        self.dataTransferService = dataTransferService
    }
    
    func getMyProfile() -> RxSwift.Observable<UserReadDTO> {
        let path = ParticleServer.Version.v1.rawValue
        + ParticleServer.Path.readMyProfile.value
        
        let endpoint = Endpoint<UserReadDTO>(
            path: path,
            method: .get
        )
        
        return dataTransferService.request(with: endpoint)
    }
    
    func setInterestedTags(tags: [String]) -> RxSwift.Observable<UserReadDTO> {
        
        /// key 값이 interestedTags로 모두 같기 때문에 dictionary 사용불가하여 tuple로 대체
        var queryParameterTuple = tags.map { ("interestedTags", $0) }
        
        let path = ParticleServer.Version.v1.rawValue
        + ParticleServer.Path.setInterestedTags.value
        
        let endpoint = Endpoint<UserReadDTO>(
            path: path,
            method: .put,
            headerParameters: ["Authorization": "Bearer \(UserDefaults.standard.string(forKey: "ACCESSTOKEN") ?? "")"],
            queryParametersTuple: queryParameterTuple
        )
        
        return dataTransferService.request(with: endpoint)
    }
}
