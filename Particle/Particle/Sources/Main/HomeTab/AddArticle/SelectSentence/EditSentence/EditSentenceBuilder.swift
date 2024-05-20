//
//  EditSentenceBuilder.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/18.
//

import RIBs

protocol EditSentenceDependency: Dependency { }

final class EditSentenceComponent: Component<EditSentenceDependency> { }

// MARK: - Builder

protocol EditSentenceBuildable: Buildable {
    func build(withListener listener: EditSentenceListener, text: String) -> EditSentenceRouting
}

final class EditSentenceBuilder: Builder<EditSentenceDependency>, EditSentenceBuildable {

    override init(dependency: EditSentenceDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: EditSentenceListener, text: String) -> EditSentenceRouting {
        _ = EditSentenceComponent(dependency: dependency)
        let viewController = EditSentenceViewController(with: text)
        let interactor = EditSentenceInteractor(presenter: viewController)
        interactor.listener = listener
        return EditSentenceRouter(interactor: interactor, viewController: viewController)
    }
}
