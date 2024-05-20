//
//  PhotoPickerRouter.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/19.
//

import RIBs

protocol PhotoPickerInteractable: Interactable {
    var router: PhotoPickerRouting? { get set }
    var listener: PhotoPickerListener? { get set }
}

protocol PhotoPickerViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class PhotoPickerRouter: ViewableRouter<PhotoPickerInteractable, PhotoPickerViewControllable>,
                               PhotoPickerRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(
        interactor: PhotoPickerInteractable,
        viewController: PhotoPickerViewControllable
    ) {
        super.init(
            interactor: interactor,
            viewController: viewController
        )
        interactor.router = self
    }
}
