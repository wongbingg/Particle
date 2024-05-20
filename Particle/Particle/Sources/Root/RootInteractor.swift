//
//  RootInteractor.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/10.
//

import RIBs
import RxSwift

protocol RootRouting: ViewableRouting {
    func attachLoggedIn()
    func detachLoggedIn()
    
    func attachLoggedOut()
    func detachLoggedOut()
}

protocol RootPresentable: Presentable {
    var listener: RootPresentableListener? { get set }
}

protocol RootListener: AnyObject {}

final class RootInteractor: PresentableInteractor<RootPresentable>,
                            RootInteractable,
                            RootPresentableListener {
    
    weak var router: RootRouting?
    weak var listener: RootListener?

    override init(presenter: RootPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        if let _ = UserDefaults.standard.string(forKey: "ACCESSTOKEN") {
            login()
        } else {
            router?.attachLoggedOut()
        }
    }

    override func willResignActive() {
        super.willResignActive()
    }
    
    // MARK: - RootInteractable
    
    func login() {
        router?.detachLoggedOut()
        router?.attachLoggedIn()
    }
    
    func logout() {
        router?.detachLoggedIn()
        router?.attachLoggedOut()
    }
}
