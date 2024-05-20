//
//  DefaultAuthService.swift
//  Particle
//
//  Created by 이원빈 on 2023/08/30.
//

import Alamofire
import RxSwift

final class DefaultAuthService: AuthService {
    private let dataTransferService: DataTransferService
    
    init(dataTransferService: DataTransferService) {
        self.dataTransferService = dataTransferService
    }
    
    func login(with body: LoginRequest) -> RxSwift.Observable<LoginSuccessResponse> {
        let path = ParticleServer.Version.v1.rawValue
        + ParticleServer.Path.login.value
        
        let endpoint = Endpoint<LoginSuccessResponse>(
            path: path,
            method: .post,
            bodyParametersEncodable: body
        )
        
        return dataTransferService.request(with: endpoint)
    }
    
    func withdraw() -> Observable<WithdrawResponse> {
        let path = ParticleServer.Version.v1.rawValue
        + ParticleServer.Path.withdraw.value
        
        let endpoint = Endpoint<WithdrawResponse>(
            path: path,
            method: .delete
        )
        
        return dataTransferService.request(with: endpoint)
    }
}
