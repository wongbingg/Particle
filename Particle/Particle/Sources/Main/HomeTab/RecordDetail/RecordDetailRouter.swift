//
//  RecordDetailRouter.swift
//  Particle
//
//  Created by 이원빈 on 2023/09/02.
//

import RIBs

protocol RecordDetailInteractable: Interactable, 
                                    OrganizingSentenceListener,
                                    SetAdditionalInformationListener {
    var router: RecordDetailRouting? { get set }
    var listener: RecordDetailListener? { get set }
}

protocol RecordDetailViewControllable: ViewControllable {
    func update(data: RecordReadDTO)
}

final class RecordDetailRouter: ViewableRouter<RecordDetailInteractable,RecordDetailViewControllable>,
                                RecordDetailRouting {
    
    init(
        interactor: RecordDetailInteractable,
        viewController: RecordDetailViewControllable,
        organizingSentenceBuildable: OrganizingSentenceBuildable,
        setAdditionalInformationBuildable: SetAdditionalInformationBuildable
    ) {
        self.organizingSentenceBuildable = organizingSentenceBuildable
        self.setAdditionalInformationBuildable = setAdditionalInformationBuildable
        super.init(
            interactor: interactor,
            viewController: viewController
        )
        interactor.router = self
    }
    
    // MARK: - OrganizingSentence RIB
    
    func attachOrganizingSentence() {
        if organizingSentenceRouting != nil {
            return
        }
        let router = organizingSentenceBuildable.build(withListener: interactor)
        viewController.pushViewController(router.viewControllable, animated: true)
        organizingSentenceRouting = router
        attachChild(router)
    }
    
    func detachOrganizingSentence() {
        guard let router = organizingSentenceRouting else {
            return
        }
        viewController.popViewController(animated: true)
        detachChild(router)
        organizingSentenceRouting = nil
    }
    
    // MARK: - SetAdditionalInformation RIB
    
    func attachSetAdditionalInformation(data: RecordReadDTO) {
        if setAdditionalInformationRouting != nil {
            return
        }
        let router = setAdditionalInformationBuildable.build(withListener: interactor, data: data)
        viewController.pushViewController(router.viewControllable, animated: true)
        setAdditionalInformationRouting = router
        attachChild(router)
    }
    
    func detachSetAdditionalInformation() {
        guard let router = setAdditionalInformationRouting else {
            return
        }
        viewController.popViewController(animated: true)
        detachChild(router)
        setAdditionalInformationRouting = nil
    }
    
    func cleanupViews(with updatedData: RecordReadDTO) {
        guard let organizingSentence = organizingSentenceRouting,
              let setAdditionalInformation = setAdditionalInformationRouting else {
            return
        }
        
        viewController.popToViewController(viewControllable, animated: true)
        
        detachChild(organizingSentence)
        detachChild(setAdditionalInformation)
        
        organizingSentenceRouting = nil
        setAdditionalInformationRouting = nil
        
        viewController.update(data: updatedData)
    }
    
    func attachRecordDetail(with data: RecordReadDTO) {}
    
    // MARK: - Private
    private let organizingSentenceBuildable: OrganizingSentenceBuildable
    private var organizingSentenceRouting: OrganizingSentenceRouting?
    
    private let setAdditionalInformationBuildable: SetAdditionalInformationBuildable
    private var setAdditionalInformationRouting: SetAdditionalInformationRouting?
}
