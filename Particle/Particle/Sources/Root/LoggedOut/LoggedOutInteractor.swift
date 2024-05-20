//
//  LoggedOutInteractor.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/10.
//

import RIBs
import RxSwift

protocol LoggedOutRouting: ViewableRouting {
    func routeToSelectTag()
}

protocol LoggedOutPresentable: Presentable {
    var listener: LoggedOutPresentableListener? { get set }
}

protocol LoggedOutListener: AnyObject {
    func login()
}

final class LoggedOutInteractor: PresentableInteractor<LoggedOutPresentable>,
                                 LoggedOutInteractable,
                                 LoggedOutPresentableListener {
    
    weak var router: LoggedOutRouting?
    weak var listener: LoggedOutListener?
    
    private let loginUseCase: LoginUseCase
    private let disposeBag = DisposeBag()
    
    init(
        presenter: LoggedOutPresentable,
        loginUseCase: LoginUseCase
    ) {
        self.loginUseCase = loginUseCase
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
    }
    
    override func willResignActive() {
        super.willResignActive()
    }
    
    // MARK: - LoggedOutPresentableListener
    
    func successLogin(with provider: String, identifier: String) {
        let request = LoginRequest(provider: provider, identifier: identifier)
        
        loginUseCase.execute(with: request)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] isFirstLogin in
                if isFirstLogin {
                    self?.router?.routeToSelectTag()
                } else {
                    self?.listener?.login()
                }
            } onError: { error in
                Console.error(error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
    
    func successLogin_Serverless() {
        if UserDefaults.standard.bool(forKey: "FIRST_LOGIN_EVENT") {
            listener?.login()
        } else {
            UserDefaults.standard.set(true, forKey: "FIRST_LOGIN_EVENT")
            UserDefaults.standard.set("사용자", forKey: "USER_NAME")
            router?.routeToSelectTag()
        }
    }
    
    // MARK: - SelectTagListener
    
    func selectTagSuccess() {
        listener?.login()
    }
}
