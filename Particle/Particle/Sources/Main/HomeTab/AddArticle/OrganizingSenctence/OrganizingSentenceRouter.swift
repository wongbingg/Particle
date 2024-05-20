//
//  OrganizingSentenceRouter.swift
//  Particle
//
//  Created by Sh Hong on 2023/07/11.
//

import RIBs

protocol OrganizingSentenceInteractable: Interactable {
    var router: OrganizingSentenceRouting? { get set }
    var listener: OrganizingSentenceListener? { get set }
}

protocol OrganizingSentenceViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class OrganizingSentenceRouter: ViewableRouter<OrganizingSentenceInteractable, OrganizingSentenceViewControllable>,
                                      OrganizingSentenceRouting {
    
    override init(
        interactor: OrganizingSentenceInteractable,
        viewController: OrganizingSentenceViewControllable
    ) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
