//
//  SetAlarmRouter.swift
//  Particle
//
//  Created by 이원빈 on 2023/09/07.
//

import RIBs

protocol SetAlarmInteractable: Interactable, DirectlySetAlarmListener {
    var router: SetAlarmRouting? { get set }
    var listener: SetAlarmListener? { get set }
}

protocol SetAlarmViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class SetAlarmRouter: ViewableRouter<SetAlarmInteractable, SetAlarmViewControllable>, SetAlarmRouting {
    
    // TODO: Constructor inject child builder protocols to allow building children.
    init(
        interactor: SetAlarmInteractable,
        viewController: SetAlarmViewControllable,
        directlySetAlarmBuildable: DirectlySetAlarmBuildable
    ) {
        self.directlySetAlarmBuildable = directlySetAlarmBuildable
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachDirectlySetAlarm() {
        if directlySetAlarmRouting != nil {
            return
        }
        let router = directlySetAlarmBuildable.build(withListener: interactor)
        viewController.pushViewController(router.viewControllable, animated: true)
        attachChild(router)
        directlySetAlarmRouting = router
    }
    
    func detachDirectlySetAlarm() {
        if let directlySetAlarm = directlySetAlarmRouting {
            viewController.popViewController(animated: true)
            detachChild(directlySetAlarm)
            directlySetAlarmRouting = nil
        }
    }
    
    private let directlySetAlarmBuildable: DirectlySetAlarmBuildable
    private var directlySetAlarmRouting: DirectlySetAlarmRouting?
}
