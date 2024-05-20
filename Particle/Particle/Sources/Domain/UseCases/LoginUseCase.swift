//
//  LoginUseCase.swift
//  Particle
//
//  Created by 이원빈 on 2023/10/12.
//

import Foundation
import RxSwift

protocol LoginUseCase {
    func execute(with request: LoginRequest) -> Observable<Bool>
}

final class DefaultLoginUseCase: LoginUseCase {
    private let authService: AuthService
    
    init(authService: AuthService) {
        self.authService = authService
    }
    
    func execute(with request: LoginRequest) -> Observable<Bool> {
        authService.login(with: request)
            .map { response in
                UserDefaults.standard.set("\(response.tokens.accessToken)", forKey: "ACCESSTOKEN")
                UserDefaults.standard.set("\(response.tokens.refreshToken)", forKey: "REFRESHTOKEN")
                return response.isNew
            }
    }
}
