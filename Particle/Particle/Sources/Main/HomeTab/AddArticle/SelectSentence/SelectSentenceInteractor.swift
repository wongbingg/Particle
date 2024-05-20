//
//  SelectSentenceInteractor.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/13.
//

import RIBs
import RxSwift

protocol SelectSentenceRouting: ViewableRouting {
    func attachEditSentence(with text: String)
    func detachEditSentence()
}

protocol SelectSentencePresentable: Presentable {
    var listener: SelectSentencePresentableListener? { get set }
    
    func updateSelectedCount(_ number: Int)
}

protocol SelectSentenceListener: AnyObject {
    func popSelectSentence()
    func pushToOrganizingSentence()
}

final class SelectSentenceInteractor: PresentableInteractor<SelectSentencePresentable>,
                                      SelectSentenceInteractable,
                                      SelectSentencePresentableListener {
    
    weak var router: SelectSentenceRouting?
    weak var listener: SelectSentenceListener?
    
    private var organizingSentenceRepository: OrganizingSentenceRepository
    
    init(
        presenter: SelectSentencePresentable,
        repository: OrganizingSentenceRepository
    ) {
        self.organizingSentenceRepository = repository
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
    }
    
    override func willResignActive() {
        super.willResignActive()
    }
    
    // MARK: - SelectSentencePresentableListener
    
    func showEditSentenceModal(with text: String) {
        router?.attachEditSentence(with: text)
    }
    
    func backButtonTapped() {
        listener?.popSelectSentence()
    }
    
    func nextButtonTapped() {
        listener?.pushToOrganizingSentence()
    }
    
    // MARK: - SelectSentenceInteractable
    
    func dismissEditSentence(with text: String?) {
        
        if let inputText = text {
            var list = organizingSentenceRepository.sentenceFile2.value
            list.append(.init(sentence: inputText, isRepresent: false))
            organizingSentenceRepository.sentenceFile2.accept(list)
            presenter.updateSelectedCount(organizingSentenceRepository.sentenceFile2.value.count)
        }

        router?.detachEditSentence()
    }
}

// FIXME: - 플로우 UT 후 변경
