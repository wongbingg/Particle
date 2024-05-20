//
//  DirectlySetAlarmRouter.swift
//  Particle
//
//  Created by 이원빈 on 2023/09/07.
//

import RIBs

protocol DirectlySetAlarmInteractable: Interactable {
    var router: DirectlySetAlarmRouting? { get set }
    var listener: DirectlySetAlarmListener? { get set }
}

protocol DirectlySetAlarmViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class DirectlySetAlarmRouter: ViewableRouter<DirectlySetAlarmInteractable, DirectlySetAlarmViewControllable>, DirectlySetAlarmRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: DirectlySetAlarmInteractable, viewController: DirectlySetAlarmViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
