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
    
    private let fetchMyProfileUseCase: FetchMyProfileUseCase
    private let setMyProfileUseCase: SetMyProfileUseCase
    private let disposeBag = DisposeBag()
    
    init(
        presenter: LoggedOutPresentable,
        fetchMyProfileUseCase: FetchMyProfileUseCase,
        setMyProfileUseCase: SetMyProfileUseCase
    ) {
        self.fetchMyProfileUseCase = fetchMyProfileUseCase
        self.setMyProfileUseCase = setMyProfileUseCase
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
    
    func successLogin_Serverless() {
        do {
            _ = try fetchMyProfileUseCase.execute()
            listener?.login()
        } catch {
            setMyProfile()
        }
    }
    
    private func setMyProfile() {
        do {
            let dto = UserReadDTO(
                id: "id",
                nickname: "사용자",
                profileImageUrl: "",
                interestedTags: [],
                interestedRecords: []
            )
            try setMyProfileUseCase.execute(dto: dto)
            router?.routeToSelectTag()
        } catch {
            Console.error(error.localizedDescription)
        }
    }
    
    // MARK: - SelectTagListener
    
    func selectTagSuccess() {
        listener?.login()
    }
}
