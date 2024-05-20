//
//  MainInteractor.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/10.
//

import RIBs
import RxSwift

protocol MainRouting: ViewableRouting {
    func attachTabs()
    func attachRecordDetail(data: RecordReadDTO)
    func detachRecordDetail()
}

protocol MainPresentable: Presentable {
    var listener: MainPresentableListener? { get set }
    
    func alert(title:String, body: String)
}

protocol MainListener: AnyObject {
    func mainLogout()
}

final class MainInteractor: PresentableInteractor<MainPresentable>,
                            MainInteractable,
                            MainPresentableListener {
    
    weak var router: MainRouting?
    weak var listener: MainListener?
    
    private let fetchRecordByIdUseCase: FetchRecordByIdUseCase
    private var disposeBag = DisposeBag()
    
    init(
        presenter: MainPresentable,
        fetchRecordByIdUseCase: FetchRecordByIdUseCase
    ) {
        self.fetchRecordByIdUseCase = fetchRecordByIdUseCase
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        router?.attachTabs()
        setupDeeplinkHandler()
    }
    
    override func willResignActive() {
        super.willResignActive()
    }
    
    // MARK: - MainInteractable
    
    func myPageLogout() {
        listener?.mainLogout()
    }
    
    func recordDetailCloseButtonTapped() {
        router?.detachRecordDetail()
    }
    
    // MARK: - Methods
    
    private func setupDeeplinkHandler() {
        
        if let recordId = try? DynamicLinkParser.shared.recordId.value() { // 링크를 통해 앱이 켜진 경우
            showParticle(id: recordId)
        }
        
        DynamicLinkParser.shared.recordId
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] value in
                if let recordId = value {
                    self?.showParticle(id: recordId)
                }
            } onError: { [weak self] error in
                self?.presenter.alert(
                    title: "오류",
                    body: error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
    
    private func showParticle(id: String) {
        fetchRecordByIdUseCase.execute(id: id)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] model in
                self?.router?.attachRecordDetail(data: model)
            } onError: { [weak self] error in
                self?.presenter.alert(
                    title: "오류",
                    body: "해당 파티클을 불러오는데 오류가 발생했습니다.\n\(id)\n\(error.localizedDescription)")
            }
            .disposed(by: disposeBag)
    }
}
