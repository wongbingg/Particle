//
//  AddArticleInteractor.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/10.
//

import RIBs
import RxSwift
import Photos

protocol AddArticleRouting: Routing {
    func cleanupViews()
    
    func attachPhotoPicker()
    func detachPhotoPicker()
    
    func attachSelectSentence(with images: [PHAsset])
    func detachSelectSentence()
    
    func attachOrganizingSentence()
    func detachOrganizingSentence()
    
    func attachSetAdditionalInformation()
    func detachSetAdditionalInformation()
    
    func attachRecordDetail(with data: RecordReadDTO)
}

protocol AddArticleListener: AnyObject {
    func recordDetailCloseButtonTapped()
}

final class AddArticleInteractor: Interactor, AddArticleInteractable {
    
    
    weak var router: AddArticleRouting?
    weak var listener: AddArticleListener?

    override init() { }

    override func didBecomeActive() {
        super.didBecomeActive()
        router?.attachPhotoPicker()
    }

    override func willResignActive() {
        super.willResignActive()
        
        router?.cleanupViews()
    }
    
    // MARK: - PhotoPickerListener
    
    func cancelButtonTapped() {
        router?.detachPhotoPicker()
    }
    
    func nextButtonTapped(with images: [PHAsset]) {
        router?.attachSelectSentence(with: images)
    }
    
    // MARK: - SelectSentenceListener
    
    func popSelectSentence() {
        router?.detachSelectSentence()
    }
    
    func pushToOrganizingSentence() {
        router?.attachOrganizingSentence()
    }
    
    // MARK: - OrganizingSentenceListener
    
    func organizingSentenceNextButtonTapped() {
        router?.attachSetAdditionalInformation()
    }
    
    func organizingSentenceBackButtonTapped() {
        router?.detachOrganizingSentence()
    }
    
    // MARK: - SetAdditionalInformationListener
    
    func setAdditionalInfoBackButtonTapped() {
        router?.detachSetAdditionalInformation()
    }
    
    func setAdditionalInfoSuccessPost(data: RecordReadDTO) {
        router?.attachRecordDetail(with: data)
    }
    
    func setAdditionalInfoSuccessEdit(data: RecordReadDTO) {}
    
    // MARK: - RecordDetailListener
    
    func recordDetailCloseButtonTapped() {
        listener?.recordDetailCloseButtonTapped()
    }
}
