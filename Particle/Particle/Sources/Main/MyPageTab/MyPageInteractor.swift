//
//  MyPageInteractor.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/18.
//

import RIBs
import RxSwift

protocol MyPageRouting: ViewableRouting {
    func attachSetAccount()
    func detachSetAccount()
    
    func attachSetAlarm()
    func detachSetAlarm()
    
    func attachSetInterestedTags()
    func detachSetInterestedTags()
}

protocol MyPagePresentable: Presentable {
    var listener: MyPagePresentableListener? { get set }
    
    func setData(data: UserReadDTO)
}

protocol MyPageListener: AnyObject {
    func myPageLogout()
}

final class MyPageInteractor: PresentableInteractor<MyPagePresentable>,
                              MyPageInteractable,
                              MyPagePresentableListener {
    
    weak var router: MyPageRouting?
    weak var listener: MyPageListener?
    
    private let fetchMyProfileUseCase: FetchMyProfileUseCase
    private var disposeBag = DisposeBag()
    
    init(
        presenter: MyPagePresentable,
        fetchMyProfileUseCase: FetchMyProfileUseCase
    ) {
        self.fetchMyProfileUseCase = fetchMyProfileUseCase
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        
//        fetchMyProfileUseCase.execute()
//            .subscribe { [weak self] dto in
//                self?.presenter.setData(data: dto)
//                UserDefaults.standard.set(dto.interestedTags.map { "#\($0)" }, forKey: "INTERESTED_TAGS")
//            } onError: { error in
//                Console.error(error.localizedDescription)
//            }
//            .disposed(by: disposeBag)
    }
    
    override func willResignActive() {
        super.willResignActive()
        
    }
    
    // MARK: - MyPagePresentableListener
    
    func setAccountButtonTapped() {
        router?.attachSetAccount()
    }
    
    func setAlarmButtonTapped() {
        router?.attachSetAlarm()
    }
    
    func setInterestedTagsButtonTapped() {
        router?.attachSetInterestedTags()
    }
    
    // MARK: - MyPageInteractable
    
    func setAccountBackButtonTapped() {
        router?.detachSetAccount()
    }
    
    func setAlarmBackButtonTapped() {
        router?.detachSetAlarm()
    }
    
    func setInterestedTagsBackButtonTapped() {
        router?.detachSetInterestedTags()
    }
    
    func setAccountLogoutButtonTapped() {
        listener?.myPageLogout()
    }
    
//    func setInterestedTagsOKButtonTapped() {
//        router?.detachSetInterestedTags()
//    }
    

}
