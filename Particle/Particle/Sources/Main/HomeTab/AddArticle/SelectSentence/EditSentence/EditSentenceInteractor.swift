//
//  EditSentenceInteractor.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/18.
//

import RIBs
import RxSwift

protocol EditSentenceRouting: ViewableRouting {}

protocol EditSentencePresentable: Presentable {
    var listener: EditSentencePresentableListener? { get set }
}

protocol EditSentenceListener: AnyObject {
    func dismissEditSentence(with text: String?)
}

final class EditSentenceInteractor: PresentableInteractor<EditSentencePresentable>,
                                    EditSentenceInteractable,
                                    EditSentencePresentableListener {

    weak var router: EditSentenceRouting?
    weak var listener: EditSentenceListener?
    
    override init(presenter: EditSentencePresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
    }
    
    override func willResignActive() {
        super.willResignActive()
    }
    
    // MARK: - EditSentencePresentableListener
    
    func saveButtonTapped(with text: String) {
        listener?.dismissEditSentence(with: text)
    }
    
    func editSentenceViewDidDisappear() {
        listener?.dismissEditSentence(with: nil)
    }
}
