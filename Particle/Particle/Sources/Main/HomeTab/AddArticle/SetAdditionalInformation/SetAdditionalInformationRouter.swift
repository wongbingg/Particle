//
//  SetAdditionalInformationRouter.swift
//  Particle
//
//  Created by Sh Hong on 2023/07/12.
//

import RIBs

protocol SetAdditionalInformationInteractable: Interactable {
    var router: SetAdditionalInformationRouting? { get set }
    var listener: SetAdditionalInformationListener? { get set }
}

protocol SetAdditionalInformationViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class SetAdditionalInformationRouter: ViewableRouter<SetAdditionalInformationInteractable, SetAdditionalInformationViewControllable>, SetAdditionalInformationRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: SetAdditionalInformationInteractable, viewController: SetAdditionalInformationViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
