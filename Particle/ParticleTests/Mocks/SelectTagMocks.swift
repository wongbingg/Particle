//
//  SelectTagMocks.swift
//  ParticleTests
//
//  Created by 이원빈 on 2024/07/25.
//

@testable import Particle

import RIBs
import RxSwift

final class SelectTagInteractableMock: SelectTagInteractable {
    
    // MARK: Variables
    var router: Particle.SelectTagRouting? { didSet { routerSetCallCount += 1 }}
    var routerSetCallCount = 0
    var listener: Particle.SelectTagListener? { didSet { listenerSetCallCount += 1 }}
    var listenerSetCallCount = 0
    var isActive: Bool = false { didSet { isActiveSetCallCount += 1 } }
    var isActiveSetCallCount = 0
    var isActiveStreamSubject: PublishSubject<Bool> = PublishSubject<Bool>() { didSet { isActiveStreamSubjectSetCallCount += 1 }}
    var isActiveStreamSubjectSetCallCount = 0
    var isActiveStream: RxSwift.Observable<Bool> { return isActiveStreamSubject }
    
    // MARK: Funtion Handlers
    var activateHandler: (() -> Void)?
    var activateCallCount: Int = 0
    var deactivateHandler: (() -> Void)?
    var deactivateCallCount: Int = 0
    var selectTagSuccessHandler: (() -> Void)?
    var selectTagSuccessCallCount: Int = 0
    
    init() {}
    
    func activate() {
        activateCallCount += 1
        if let activateHandler = activateHandler {
            return activateHandler()
        }
    }
    
    func deactivate() {
        deactivateCallCount += 1
        if let deactivateHandler = deactivateHandler {
            return deactivateHandler()
        }
    }
}

final class SelectTagViewControllableMock: SelectTagViewControllable {
    // MARK: Variables
    var uiviewController: UIViewController = UIViewController() { didSet { uiviewControllerSetCallCount += 1 } }
    var uiviewControllerSetCallCount = 0
    
    // MARK: Fucntion Handlers
    var present: ((ViewControllable) -> Void)?
    var presentCallCount: Int = 0
    
    init() {}
    
    func present(viewController: RIBs.ViewControllable) {
        presentCallCount += 1
        if let present = present {
            present(viewController)
        }
    }
}

final class SelectTagBuildableMock: SelectTagBuildable {
    
    // MARK: Function Handlers
    var buildHandler: ((_ listener: SelectTagListener) -> SelectTagRouting)?
    var buildCallCount: Int = 0
    
    init(){}
    
    func build(withListener listener: Particle.SelectTagListener) -> Particle.SelectTagRouting {
        buildCallCount += 1
        if let buildHandler = buildHandler {
            return buildHandler(listener)
        }
        fatalError("Function build returns a value that can't be handled with a default value and its handler must be set")
    }
}
