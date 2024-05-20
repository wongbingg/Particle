//
//  SetInterestedTagsInteractor.swift
//  Particle
//
//  Created by 이원빈 on 2023/09/10.
//

import RIBs
import RxSwift

protocol SetInterestedTagsRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol SetInterestedTagsPresentable: Presentable {
    var listener: SetInterestedTagsPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
    
    func showUploadSuccessAlert()
    func showErrorAlert(description: String)
}

protocol SetInterestedTagsListener: AnyObject {
    func setInterestedTagsBackButtonTapped()
//    func setInterestedTagsOKButtonTapped()
}

final class SetInterestedTagsInteractor: PresentableInteractor<SetInterestedTagsPresentable>,
                                         SetInterestedTagsInteractable,
                                         SetInterestedTagsPresentableListener {

    weak var router: SetInterestedTagsRouting?
    weak var listener: SetInterestedTagsListener?
    private let setInterestedTagsUseCase: SetInterestedTagsUseCase
    private var disposeBag = DisposeBag()

    init(
        presenter: SetInterestedTagsPresentable,
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
    
    // MARK: - SelectInterestedTagsPresentableListener
    
    func setInterestedTagsBackButtonTapped() {
        listener?.setInterestedTagsBackButtonTapped()
    }
    
    func setInterestedTagsOKButtonTapped(with tags: [String]) {

        setInterestedTagsUseCase.execute(tags: tags)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] dto in
                self?.presenter.showUploadSuccessAlert()
            } onError: { [weak self] error in
                if case DataTransferError.resolvedNetworkFailure(let errorResponse as ErrorResponse) = error {
                    self?.presenter.showErrorAlert(description: errorResponse.toDomain())
                } else {
                    self?.presenter.showErrorAlert(description: "알 수 없는 에러가 발생했습니다.\n다시 시도해주세요.\ndescription: \(error.localizedDescription)")
                }
            }
            .disposed(by: disposeBag)
    }
    
    func setInterestedTagsOKButtonTapped_Serverless(with tags: [String]) {
        UserDefaults.standard.set(tags.map { "#\($0)" }, forKey: "INTERESTED_TAGS") // # 붙이는게 맞나 ?
        presenter.showUploadSuccessAlert()
    }
}
