//
//  LoggedOutRouter.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/10.
//

import RIBs

protocol LoggedOutInteractable: Interactable, SelectTagListener {
    var router: LoggedOutRouting? { get set }
    var listener: LoggedOutListener? { get set }
}

protocol LoggedOutViewControllable: ViewControllable {
    func present(viewController: ViewControllable)
}

final class LoggedOutRouter: ViewableRouter<LoggedOutInteractable,LoggedOutViewControllable>,
                             LoggedOutRouting {
    
    init(
        interactor: LoggedOutInteractable,
        viewController: LoggedOutViewControllable,
        selecTagBuilder: SelectTagBuildable
    ) {
        self.selectTagBuilder = selecTagBuilder
        super.init(
            interactor: interactor,
            viewController: viewController
        )
        interactor.router = self
    }
    
    func routeToSelectTag() {
        if selectTagRouting != nil {
            return
        }
        let router = selectTagBuilder.build(withListener: interactor)
        self.selectTagRouting = router
        attachChild(router)
        viewController.present(viewController: router.viewControllable)
    }
    
    // MARK: - Private
    
    private let selectTagBuilder: SelectTagBuildable
    private var selectTagRouting: ViewableRouting?
}
