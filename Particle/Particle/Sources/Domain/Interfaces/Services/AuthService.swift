//
//  AuthService.swift
//  Particle
//
//  Created by 이원빈 on 2023/10/12.
//

import RxSwift
import Foundation

protocol AuthService {
    func login(with body: LoginRequest) -> Observable<LoginSuccessResponse>
    func withdraw() -> Observable<WithdrawResponse>
}
