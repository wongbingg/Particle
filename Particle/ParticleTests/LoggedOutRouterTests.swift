//
//  LoggedOutRouterTests.swift
//  ParticleTests
//
//  Created by 이원빈 on 2024/07/25.
//

@testable import Particle
import XCTest

import RxSwift

final class LoggedOutRouterTests: XCTestCase {

    private var router: LoggedOutRouting!
    
    private var interactor: LoggedOutInteractableMock!
    private var viewController: LoggedOutViewControllableMock!
    private var childBuilder: SelectTagBuildableMock!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
    
        interactor = LoggedOutInteractableMock()
        viewController = LoggedOutViewControllableMock()
        childBuilder = SelectTagBuildableMock()

        router = LoggedOutRouter(
            interactor: self.interactor,
            viewController: self.viewController,
            selecTagBuilder: self.childBuilder
        )
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    // MARK: - Tests

    func test_routeToSelectTag수행시_childBuilder가_build를실행하는지() {
        // given
        let expectedCallCount = 1
        childBuilder.buildHandler = { listener in
            let viewController = SelectTagViewControllableMock()
            let interactor = SelectTagInteractableMock()
            interactor.listener = listener
            return SelectTagRouter(interactor: interactor, viewController: viewController)
        }
        
        // when
        router.routeToSelectTag()
        
        // then
        XCTAssertEqual(childBuilder.buildCallCount, expectedCallCount)
        XCTAssertEqual(viewController.presentCallCount, expectedCallCount)
    }
}
