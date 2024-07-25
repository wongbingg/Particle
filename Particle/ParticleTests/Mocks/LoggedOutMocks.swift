//
//  LoggedOutMocks.swift
//  ParticleTests
//
//  Created by 이원빈 on 2024/07/25.
//

@testable import Particle

import RIBs
import RxSwift

final class LoggedOutRoutingMock: LoggedOutRouting {
    // MARK: Variables
    var interactable: RIBs.Interactable { didSet { interactableSetCallCount += 1 } }
    var interactableSetCallCount = 0
    var children: [RIBs.Routing] = [Routing]() { didSet { childrenSetCallCount += 1} }
    var childrenSetCallCount = 0
    var viewControllable: RIBs.ViewControllable { didSet { viewControllableSetCallCount += 1 } }
    var viewControllableSetCallCount = 0
    var lifecycleSubject: PublishSubject<RouterLifecycle> = PublishSubject<RouterLifecycle>() {
        didSet { lifecycleSubjectSetCallCount += 1 }
    }
    var lifecycleSubjectSetCallCount = 0
    var lifecycle: RxSwift.Observable<RIBs.RouterLifecycle> { return lifecycleSubject }
    
    // MARK: Function Handlers
    var routeToSelectTagHandler: (() -> Void)?
    var routeToSelectCallCount = 0
    var loadHandler: (() -> Void)?
    var loadCallCount = 0
    var attachChildHandler: ((_ child: Routing) -> Void)?
    var attachChildCallCount = 0
    var detachChildHandler: ((_ child: Routing) -> Void)?
    var detachChildCallCount = 0
    
    init(interactable: Interactable, viewControllable: ViewControllable) {
        self.interactable = interactable
        self.viewControllable = viewControllable
    }
    
    func routeToSelectTag() {
        routeToSelectCallCount += 1
        if let routeToSelectTagHandler = routeToSelectTagHandler {
            routeToSelectTagHandler()
        }
    }
    
    func load() {
        loadCallCount += 1
        if let loadHandler = loadHandler {
            loadHandler()
        }
    }
    
    func attachChild(_ child: RIBs.Routing) {
        attachChildCallCount += 1
        if let attachChildHandler = attachChildHandler {
            attachChildHandler(child)
        }
    }
    
    func detachChild(_ child: RIBs.Routing) {
        detachChildCallCount += 1
        if let detachChildHandler = detachChildHandler {
            detachChildHandler(child)
        }
    }
}

final class LoggedOutInteractableMock: LoggedOutInteractable {
    
    // MARK: Variables
    var router: Particle.LoggedOutRouting? { didSet { routerSetCallCount += 1 }}
    var routerSetCallCount = 0
    var listener: Particle.LoggedOutListener? { didSet { listenerSetCallCount += 1 }}
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
    
    func selectTagSuccess() {
        selectTagSuccessCallCount += 1
        if let selectTagSuccessHandler = selectTagSuccessHandler {
            return selectTagSuccessHandler()
        }
    }
}

final class LoggedOutViewControllableMock: LoggedOutViewControllable {
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

final class LoggedOutBuildableMock: LoggedOutBuildable {
    
    // MARK: Function Handlers
    var buildHandler: ((_ listener: LoggedOutListener) -> LoggedOutRouting)?
    var buildCallCount: Int = 0
    
    init(){}
    
    func build(withListener listener: Particle.LoggedOutListener) -> Particle.LoggedOutRouting {
        buildCallCount += 1
        if let buildHandler = buildHandler {
            return buildHandler(listener)
        }
        fatalError("Function build returns a value that can't be handled with a default value and its handler must be set")
    }
}

final class LoggedOutPresentableMock: LoggedOutPresentable {
    var listener: Particle.LoggedOutPresentableListener? { didSet { listenerSetCallCount += 1} }
    var listenerSetCallCount = 0
}
