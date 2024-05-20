//
//  SelectTagInteractor.swift
//  Particle
//
//  Created by 이원빈 on 2023/08/24.
//

import RIBs
import RxSwift

protocol SelectTagRouting: ViewableRouting {}

protocol SelectTagPresentable: Presentable {
    var listener: SelectTagPresentableListener? { get set }
    
    func showErrorAlert(description: String)
}

protocol SelectTagListener: AnyObject {
    func selectTagSuccess()
}

final class SelectTagInteractor: PresentableInteractor<SelectTagPresentable>,
                                 SelectTagInteractable,
                                 SelectTagPresentableListener {
    
    weak var router: SelectTagRouting?
    weak var listener: SelectTagListener?
    private var disposeBag = DisposeBag()
    private let setInterestedTagsUseCase: SetInterestedTagsUseCase
    
    init(
        presenter: SelectTagPresentable,
        setInterestedTagsUseCase: SetInterestedTagsUseCase
    ) {
        self.setInterestedTagsUseCase = setInterestedTagsUseCase
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
    }
    
    override func willResignActive() {
        super.willResignActive()
    }
    
    // MARK: - SelectTagPresentableListener
    
    func backButtonTapped() {
        // TODO: LoggedOut RIB로 돌아가기?
    }
    
    func startButtonTapped(with selectedTags: [String]) {

        setInterestedTagsUseCase.execute(tags: selectedTags)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] isComplete in
                if isComplete {
                    self?.listener?.selectTagSuccess()
                }
            } onError: { [weak self] error in
                if case DataTransferError.resolvedNetworkFailure(let errorResponse as ErrorResponse) = error {
                    self?.presenter.showErrorAlert(description: errorResponse.toDomain())
                } else {
                    self?.presenter.showErrorAlert(description: error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
    }
    
    func startButtonTapped_Serverless(with selectedTags: [String]) {
        UserDefaults.standard.set(selectedTags.map { "#\($0)" }, forKey: "INTERESTED_TAGS")
        listener?.selectTagSuccess()
    }
}
