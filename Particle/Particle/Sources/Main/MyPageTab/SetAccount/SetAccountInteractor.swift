//
//  SetAccountInteractor.swift
//  Particle
//
//  Created by 이원빈 on 2023/09/07.
//

import RIBs
import RxSwift

protocol SetAccountRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol SetAccountPresentable: Presentable {
    var listener: SetAccountPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
    func showErrorAlert(description: String)
    func showSuccessAlert()
}

protocol SetAccountListener: AnyObject {
    func setAccountBackButtonTapped()
    func setAccountLogoutButtonTapped()
}

final class SetAccountInteractor: PresentableInteractor<SetAccountPresentable>, SetAccountInteractable, SetAccountPresentableListener {
    
    private var disposeBag = DisposeBag()
    weak var router: SetAccountRouting?
    weak var listener: SetAccountListener?
    
    private let withdrawUseCase: WithdrawUseCase

    init(
        presenter: SetAccountPresentable,
        withdrawUseCase: WithdrawUseCase
    ) {
        self.withdrawUseCase = withdrawUseCase
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
    
    // MARK: - SetAccountPresentableListener
    
    func backButtonTapped() {
        listener?.setAccountBackButtonTapped()
    }
    
    func deleteAccountButtonTapped() {

        withdrawUseCase.execute()
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] data in

                if (200..<300).contains(data.status) {
                    self?.presenter.showSuccessAlert()
                } else {
                    self?.presenter.showErrorAlert(description: "status: \(data.status)\ncode:\(data.code)\nmessage: \(data.message)")
                }
            } onError: { [weak self] error in
                /// 회원탈퇴 에러??
                self?.presenter.showErrorAlert(description: error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
    
    func logoutButtonTapped() {
//        UserDefaults.standard.removeObject(forKey: "ACCESSTOKEN")
//        UserDefaults.standard.removeObject(forKey: "REFRESHTOKEN")
//        UserDefaults.standard.removeObject(forKey: "INTERESTED_TAGS")
        listener?.setAccountLogoutButtonTapped()
    }
}
