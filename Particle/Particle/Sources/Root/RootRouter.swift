//
//  RootRouter.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/10.
//

import RIBs

protocol RootInteractable: Interactable, LoggedOutListener, LoggedInListener {
    var router: RootRouting? { get set }
    var listener: RootListener? { get set }
}

protocol RootViewControllable: ViewControllable {
    func present(viewController: ViewControllable)
    func dismiss(viewController: ViewControllable)
}

final class RootRouter: LaunchRouter<RootInteractable, RootViewControllable>, RootRouting {

    private let loggedOutBuilder: LoggedOutBuildable
    private var loggedOutRouting: ViewableRouting?
    
    private let loggedInBuilder: LoggedInBuildable
    private var loggedInRouting: Routing?
    
    init(
        interactor: RootInteractor,
        viewController: RootViewControllable,
        loggedOutBuilder: LoggedOutBuildable,
        loggedInBuilder: LoggedInBuildable
    ) {
        self.loggedOutBuilder = loggedOutBuilder
        self.loggedInBuilder = loggedInBuilder
        super.init(
            interactor: interactor,
            viewController: viewController
        )
        interactor.router = self
    }
    
    override func didLoad() {
        super.didLoad()
    }
    
    // MARK: - RootRouting
    
    func attachLoggedIn() {
        if loggedInRouting != nil {
            return
        }
        let loggedIn = loggedInBuilder.build(
            withListener: interactor
        )
        loggedInRouting = loggedIn
        attachChild(loggedIn)
    }
    
    func detachLoggedIn() {
        guard let router = loggedInRouting else {
            return
        }
        detachChild(router)
        loggedInRouting = nil
    }
    
    func attachLoggedOut() {
        if loggedOutRouting != nil {
            return 
        }
        let loggedOut = loggedOutBuilder.build(withListener: interactor)
        self.loggedOutRouting = loggedOut
        attachChild(loggedOut)
        viewController.present(viewController: loggedOut.viewControllable)
    }
    
    func detachLoggedOut() {
        guard let router = loggedOutRouting else {
            return
        }
        viewController.dismiss(viewController: router.viewControllable)
        detachChild(router)
        loggedOutRouting = nil
    }
}
