//
//  LoggedInRouter.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/10.
//

import RIBs

protocol LoggedInInteractable: Interactable, MainListener {
    var router: LoggedInRouting? { get set }
    var listener: LoggedInListener? { get set }
}

protocol LoggedInViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy. Since
    // this RIB does not own its own view, this protocol is conformed to by one of this
    // RIB's ancestor RIBs' view.
    func present(viewController: ViewControllable)
}

final class LoggedInRouter: Router<LoggedInInteractable>, LoggedInRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    init(
        interactor: LoggedInInteractable,
        viewController: LoggedInViewControllable,
        mainBuilder: MainBuildable
    ) {
        self.viewController = viewController
        self.mainBuilder = mainBuilder
        super.init(interactor: interactor)
        interactor.router = self
    }
    
    override func didLoad() {
        super.didLoad()
        attachMain()
    }

    func cleanupViews() {
        // TODO: Since this router does not own its view, it needs to cleanup the views
        // it may have added to the view hierarchy, when its interactor is deactivated.
        detachMain()
    }

    // MARK: - Private

    private let viewController: LoggedInViewControllable
    private let mainBuilder: MainBuildable
    private var currentChild: ViewableRouting?
    
    private func attachMain() {
        let main = mainBuilder.build(withListener: interactor)
        self.currentChild = main
        attachChild(main)
        viewController.present(viewController: main.viewControllable)
    }
    
    private func detachMain() {
        if let main = currentChild {
            viewController.dismiss(completion: nil)
            detachChild(main)
            currentChild = nil
        }
    }
}
