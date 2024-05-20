//
//  WithdrawalUseCase.swift
//  Particle
//
//  Created by 이원빈 on 2023/11/02.
//

import Foundation
import RxSwift

protocol WithdrawUseCase {
    func execute() -> Observable<WithdrawResponse>
}

final class DefaultWithdrawUseCase: WithdrawUseCase {
    
    private let authService: AuthService
    
    init(authService: AuthService) {
        self.authService = authService
    }
    
    func execute() -> Observable<WithdrawResponse> {
        UserDefaults.standard.removeObject(forKey: "ACCESSTOKEN")
        UserDefaults.standard.removeObject(forKey: "REFRESHTOKEN")
        UserDefaults.standard.removeObject(forKey: "INTERESTED_TAGS")
        return authService.withdraw()
    }
}
