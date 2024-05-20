//
//  AddArticleRouter.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/10.
//

import RIBs
import Photos

protocol AddArticleInteractable: Interactable,
                                 PhotoPickerListener,
                                 SelectSentenceListener,
                                 OrganizingSentenceListener,
                                 SetAdditionalInformationListener,
                                 RecordDetailListener {
    
    var router: AddArticleRouting? { get set }
    var listener: AddArticleListener? { get set }
}

protocol AddArticleViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy. Since
    // this RIB does not own its own view, this protocol is conformed to by one of this
    // RIB's ancestor RIBs' view.
}

final class AddArticleRouter: Router<AddArticleInteractable>, AddArticleRouting {
    
    private var navigationControllable: NavigationControllerable?
    
    private let photoPickerBuildable: PhotoPickerBuildable
    private var photoPickerRouting: PhotoPickerRouting?
    
    private let selectSentenceBuildable: SelectSentenceBuildable
    private var selectSentenceRouting: SelectSentenceRouting?
    
    private let organizingSentenceBuildable: OrganizingSentenceBuildable
    private var organizingSentenceRouting: OrganizingSentenceRouting?
    
    private let setAdditionalInformationBuildable: SetAdditionalInformationBuildable
    private var setAdditionalInformationRouting: SetAdditionalInformationRouting?
    
    private let recordDetailBuildable: RecordDetailBuildable
    private var recordDetailRouting: RecordDetailRouting?
    
    init(
        interactor: AddArticleInteractable,
        viewController: ViewControllable,
        photoPickerBuildable: PhotoPickerBuildable,
        selectSentenceBuildable: SelectSentenceBuildable,
        organizingSentenceBuildable: OrganizingSentenceBuildable,
        setAdditionalInformationBuildable: SetAdditionalInformationBuildable,
        recordDetailBuildable: RecordDetailBuildable
    ) {
        self.viewController = viewController
        self.selectSentenceBuildable = selectSentenceBuildable
        self.photoPickerBuildable = photoPickerBuildable
        self.organizingSentenceBuildable = organizingSentenceBuildable
        self.setAdditionalInformationBuildable = setAdditionalInformationBuildable
        self.recordDetailBuildable = recordDetailBuildable
        super.init(interactor: interactor)
        interactor.router = self
    }
    
    // MARK: - PhotoPicker RIB
    
    func attachPhotoPicker() {
        if photoPickerRouting != nil {
            return
        }
        let router = photoPickerBuildable.build(withListener: interactor)
        
        presentInsideNavigation(router.viewControllable)
        
        attachChild(router)
        photoPickerRouting = router
    }
    
    func detachPhotoPicker() {
        guard let router = photoPickerRouting else {
            return
        }
        dismissPresentedNavigation(completion: nil)
        detachChild(router)
        photoPickerRouting = nil
        
    }
    
    // MARK: - SelectSentence RIB
    
    func attachSelectSentence(with images: [PHAsset]) {
        if selectSentenceRouting != nil {
            return
        }
        let router = selectSentenceBuildable.build(
            withListener: interactor,
            images: images
        )
        navigationControllable?.pushViewController(router.viewControllable, animated: true)
        selectSentenceRouting = router
        attachChild(router)
    }
    
    func detachSelectSentence() {
        guard let router = selectSentenceRouting else {
            return
        }
        navigationControllable?.popViewController(animated: true)
        detachChild(router)
        selectSentenceRouting = nil
    }
    
    // MARK: - OrganizingSentence RIB
    
    func attachOrganizingSentence() {
        if organizingSentenceRouting != nil {
            return
        }
        let router = organizingSentenceBuildable.build(withListener: interactor)
        navigationControllable?.pushViewController(router.viewControllable, animated: true)
        organizingSentenceRouting = router
        attachChild(router)
    }
    
    func detachOrganizingSentence() {
        guard let router = organizingSentenceRouting else {
            return
        }
        navigationControllable?.popViewController(animated: true)
        detachChild(router)
        organizingSentenceRouting = nil
    }
    
    // MARK: - SetAdditionalInformation RIB
    
    func attachSetAdditionalInformation() {
        if setAdditionalInformationRouting != nil {
            return
        }
        let router = setAdditionalInformationBuildable.build(withListener: interactor, data: nil)
        navigationControllable?.pushViewController(router.viewControllable, animated: true)
        setAdditionalInformationRouting = router
        attachChild(router)
    }
    
    func detachSetAdditionalInformation() {
        guard let router = setAdditionalInformationRouting else {
            return
        }
        navigationControllable?.popViewController(animated: true)
        detachChild(router)
        setAdditionalInformationRouting = nil
    }
    
    // MARK: - RecordDetail RIB
    
    func attachRecordDetail(with data: RecordReadDTO) {
        if recordDetailRouting != nil {
            return
        }
        let router = recordDetailBuildable.build(withListener: interactor, data: data, editable: false)
        navigationControllable?.pushViewController(router.viewControllable, animated: true)
        recordDetailRouting = router
        attachChild(router)
    }
    
    func cleanupViews() {
        if viewController.uiviewController.presentedViewController != nil, navigationControllable != nil {
            navigationControllable?.dismiss(completion: nil)
        }
    }
    
    // MARK: - Private
    private let viewController: ViewControllable
    
    private func presentInsideNavigation(_ viewControllable: ViewControllable) {
        let navigation = NavigationControllerable(root: viewControllable)
        navigation.navigationController.modalPresentationStyle = .fullScreen
        self.navigationControllable = navigation
        viewController.present(navigation, animated: true, completion: nil)
    }
    
    private func dismissPresentedNavigation(completion: (() -> Void)?) {
        if self.navigationControllable == nil {
            return
        }
        
        viewController.dismiss(completion: nil)
        self.navigationControllable = nil
    }
}
