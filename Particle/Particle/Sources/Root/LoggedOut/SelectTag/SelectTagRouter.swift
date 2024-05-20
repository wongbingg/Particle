//
//  SelectTagRouter.swift
//  Particle
//
//  Created by 이원빈 on 2023/08/24.
//

import RIBs

protocol SelectTagInteractable: Interactable {
    var router: SelectTagRouting? { get set }
    var listener: SelectTagListener? { get set }
}

protocol SelectTagViewControllable: ViewControllable {}

final class SelectTagRouter: ViewableRouter<SelectTagInteractable, SelectTagViewControllable>,
                             SelectTagRouting {

    override init(interactor: SelectTagInteractable, viewController: SelectTagViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
