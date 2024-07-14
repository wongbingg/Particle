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
    
    func startButtonTapped_Serverless(with selectedTags: [String]) {
        do {
            try setInterestedTagsUseCase.execute(tags: selectedTags)
            listener?.selectTagSuccess()
        } catch {
            self.presenter.showErrorAlert(description: "\(error.localizedDescription)")
            // FIXME: 화면쪽으로 에러 얼럿 띄우도록 수정
        }
    }
}
