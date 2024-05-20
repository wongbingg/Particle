//
//  SetAccountRouter.swift
//  Particle
//
//  Created by 이원빈 on 2023/09/07.
//

import RIBs

protocol SetAccountInteractable: Interactable {
    var router: SetAccountRouting? { get set }
    var listener: SetAccountListener? { get set }
}

protocol SetAccountViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class SetAccountRouter: ViewableRouter<SetAccountInteractable, SetAccountViewControllable>, SetAccountRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: SetAccountInteractable, viewController: SetAccountViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
