//
//  LoggedOutInteractorTests.swift
//  ParticleTests
//
//  Created by 이원빈 on 2024/07/25.
//

@testable import Particle
import XCTest

final class LoggedOutInteractorTests: XCTestCase {

    private var interactor: LoggedOutInteractor!
    
    private var loggedOutPresentableMock: LoggedOutPresentableMock!
    private var fetchMyProfileUseCaseMock: FetchMyProfileUseCaseMock!
    private var setMyProfileUseCaseMock: SetMyProfileUseCaseMock!

    override func setUpWithError() throws {
        try super.setUpWithError()
        loggedOutPresentableMock = LoggedOutPresentableMock()
        fetchMyProfileUseCaseMock = FetchMyProfileUseCaseMock()
        setMyProfileUseCaseMock = SetMyProfileUseCaseMock()
        
        interactor = LoggedOutInteractor(
            presenter: loggedOutPresentableMock,
            fetchMyProfileUseCase: fetchMyProfileUseCaseMock,
            setMyProfileUseCase: setMyProfileUseCaseMock)
        
        loggedOutRoutingMock = LoggedOutRoutingMock(
            interactable: interactor,
            viewControllable: LoggedOutViewControllableMock())
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        interactor = nil
    }

    // MARK: - Tests

    func test_selectTag화면에서_성공을전달받을때_000되는지() {
        // given
        let expectedCallCount = 1
        
        // when
        interactor.selectTagSuccess()
        
        // then
    }
}
