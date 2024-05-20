//
//  SelectSentenceRouter.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/18.
//

import RIBs

protocol SelectSentenceInteractable: Interactable, EditSentenceListener {
    var router: SelectSentenceRouting? { get set }
    var listener: SelectSentenceListener? { get set }
}

protocol SelectSentenceViewControllable: ViewControllable {
    func present(viewController: ViewControllable)
    func dismiss(viewController: ViewControllable)
}

final class SelectSentenceRouter: ViewableRouter<SelectSentenceInteractable,
                                  SelectSentenceViewControllable>,
                                  SelectSentenceRouting {

    init(
        interactor: SelectSentenceInteractable,
        viewController: SelectSentenceViewControllable,
        editSentenceBuilder: EditSentenceBuildable
    ) {
        self.editSentenceBuilder = editSentenceBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachEditSentence(with text: String) {
        if currentChild != nil {
            return
        }
        let editSentence = editSentenceBuilder.build(withListener: interactor, text: text)
        self.currentChild = editSentence
        attachChild(editSentence)
        viewController.present(viewController: editSentence.viewControllable)
    }
    
    func detachEditSentence() {
        
        if let editSentence = currentChild {
            detachChild(editSentence)
            viewController.dismiss(viewController: editSentence.viewControllable)
            currentChild = nil
        }
    }
    
    // MARK: - Private
    
    private let editSentenceBuilder: EditSentenceBuildable
    private var currentChild: ViewableRouting?
    
}
