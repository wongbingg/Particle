//
//  OrganizingSentenceInteractor.swift
//  Particle
//
//  Created by Sh Hong on 2023/07/11.
//

import RIBs
import RxSwift

protocol OrganizingSentenceRouting: ViewableRouting {
    
}

protocol OrganizingSentencePresentable: Presentable {
    var listener: OrganizingSentencePresentableListener? { get set }
    
    func setUpData(with viewModels: [OrganizingSentenceViewModel])
}

protocol OrganizingSentenceListener: AnyObject {
    func organizingSentenceNextButtonTapped()
    func organizingSentenceBackButtonTapped()
}

final class OrganizingSentenceInteractor: PresentableInteractor<OrganizingSentencePresentable>,
                                          OrganizingSentenceInteractable,
                                          OrganizingSentencePresentableListener {

    weak var router: OrganizingSentenceRouting?
    weak var listener: OrganizingSentenceListener?

    private let organizingSentenceRepository: OrganizingSentenceRepository
    private var disposeBag: DisposeBag = .init()
    
    init(
        presenter: OrganizingSentencePresentable,
        dependency: OrganizingSentenceRepository
    ) {
        self.organizingSentenceRepository = dependency
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        organizingSentenceRepository.sentenceFile2.bind { [weak self] in
            self?.presenter.setUpData(with: $0)
        }
        .disposed(by: disposeBag)
    }

    override func willResignActive() {
        super.willResignActive()
    }
    
    // MARK: - OrganizingSentencePresentableListener
    
    func nextButtonTapped(with data: [OrganizingSentenceViewModel]) {
        organizingSentenceRepository.sentenceFile2.accept(data)
        
        listener?.organizingSentenceNextButtonTapped()
    }
    
    func backButtonTapped() {
        listener?.organizingSentenceBackButtonTapped()
    }
}
