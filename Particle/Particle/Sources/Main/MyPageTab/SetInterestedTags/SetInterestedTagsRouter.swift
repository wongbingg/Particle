//
//  SetInterestedTagsRouter.swift
//  Particle
//
//  Created by 이원빈 on 2023/09/10.
//

import RIBs

protocol SetInterestedTagsInteractable: Interactable {
    var router: SetInterestedTagsRouting? { get set }
    var listener: SetInterestedTagsListener? { get set }
}

protocol SetInterestedTagsViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class SetInterestedTagsRouter: ViewableRouter<SetInterestedTagsInteractable, SetInterestedTagsViewControllable>, SetInterestedTagsRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: SetInterestedTagsInteractable, viewController: SetInterestedTagsViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
