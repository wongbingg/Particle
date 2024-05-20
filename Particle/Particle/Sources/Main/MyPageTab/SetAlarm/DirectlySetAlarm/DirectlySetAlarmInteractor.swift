//
//  DirectlySetAlarmInteractor.swift
//  Particle
//
//  Created by 이원빈 on 2023/09/07.
//

import RIBs
import RxSwift

protocol DirectlySetAlarmRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol DirectlySetAlarmPresentable: Presentable {
    var listener: DirectlySetAlarmPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol DirectlySetAlarmListener: AnyObject {
    func directlySetAlarmCloseButtonTapped()
}

final class DirectlySetAlarmInteractor: PresentableInteractor<DirectlySetAlarmPresentable>,
                                            DirectlySetAlarmInteractable,
                                            DirectlySetAlarmPresentableListener {
    
    weak var router: DirectlySetAlarmRouting?
    weak var listener: DirectlySetAlarmListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: DirectlySetAlarmPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    // MARK: - DirectlySetAlarmPresentableListener
    
    func directlySetAlarmCloseButtonTapped() {
        listener?.directlySetAlarmCloseButtonTapped()
    }
    

}
