//
//  ExploreRouter.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/18.
//

import RIBs

protocol ExploreInteractable: Interactable {
    var router: ExploreRouting? { get set }
    var listener: ExploreListener? { get set }
}

protocol ExploreViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class ExploreRouter: ViewableRouter<ExploreInteractable, ExploreViewControllable>, ExploreRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: ExploreInteractable, viewController: ExploreViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
