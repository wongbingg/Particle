//
//  UseCaseMocks.swift
//  ParticleTests
//
//  Created by 이원빈 on 2024/07/25.
//

@testable import Particle

final class FetchMyProfileUseCaseMock: FetchMyProfileUseCase {
    var excuteHadler: (() -> UserReadDTO)?
    var excuteCallCount = 0
    
    func execute() throws -> Particle.UserReadDTO {
        excuteCallCount += 1
        if let excuteHadler = excuteHadler {
            return excuteHadler()
        }
        fatalError("error was found")
    }
}

final class SetMyProfileUseCaseMock: SetMyProfileUseCase {
    var excuteHadler: ((UserReadDTO) -> Void)?
    var excuteCallCount = 0
    
    func execute(dto: UserReadDTO) throws {
        excuteCallCount += 1
        if let excuteHadler = excuteHadler {
            excuteHadler(dto)
        }
    }
}
