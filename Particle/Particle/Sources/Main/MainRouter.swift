//
//  MainRouter.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/10.
//

import RIBs

protocol MainInteractable: Interactable,
                           HomeListener,
                           ExploreListener,
                           SearchListener,
                           MyPageListener,
                           RecordDetailListener {
    var router: MainRouting? { get set }
    var listener: MainListener? { get set }
}

protocol MainViewControllable: ViewControllable {
    func present(viewController: ViewControllable)
    func dismiss(viewController: ViewControllable)
    func setViewControllers(_ viewControllers: [ViewControllable])
}

final class MainRouter: ViewableRouter<MainInteractable, MainViewControllable>, MainRouting {
    
    
    private var navigationControllable: NavigationControllerable?
    
    private let home: HomeBuildable
//    private let explore: ExploreBuildable
//    private let search: SearchBuildable
    private let mypage: MyPageBuildable
    
    private var homeRouting: ViewableRouting?
//    private var exploreRouting: ViewableRouting?
//    private var searchRouting: ViewableRouting?
    private var mypageRouting: ViewableRouting?
    
    // deeplink
    private let recordDetail: RecordDetailBuildable
    private var recordDetailRouting: RecordDetailRouting?
    
    init(
        interactor: MainInteractable,
        viewController: MainViewControllable,
        home: HomeBuildable,
//        explore: ExploreBuildable,
//        search: SearchBuildable,
        mypage: MyPageBuildable,
        recordDetail: RecordDetailBuildable
    ) {
        self.home = home
//        self.explore = explore
//        self.search = search
        self.mypage = mypage
        self.recordDetail = recordDetail
        
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachTabs() {
        let mypage = mypage.build(withListener: interactor)
        let home = home.build(withListener: interactor)
//        let explore = explore.build(withListener: interactor)
//        let search = search.build(withListener: interactor)
        
        attachChild(mypage) /// interestedTag 를 빨리 얻기위해
        attachChild(home)
//        attachChild(explore)
//        attachChild(search)
        
        let viewControllers = [
            NavigationControllerable(root: home.viewControllable),
//            NavigationControllerable(root: explore.viewControllable),
//            NavigationControllerable(root: search.viewControllable),
            NavigationControllerable(root: mypage.viewControllable)
        ]
        
        viewController.setViewControllers(viewControllers)
    }
    
    // MARK: - RecordDetail RIB
    
    func attachRecordDetail(data: RecordReadDTO) {
        if recordDetailRouting != nil {
            return
        }
        let router = recordDetail.build(withListener: interactor, data: data, editable: true)
        viewController.present(router.viewControllable, animated: true, completion: nil)
        attachChild(router)
        recordDetailRouting = router
    }
    
    func detachRecordDetail() {
        if let recordDetail = recordDetailRouting {
            viewController.dismiss(viewController: recordDetail.viewControllable)
            detachChild(recordDetail)
            recordDetailRouting = nil
        }
    }
}
