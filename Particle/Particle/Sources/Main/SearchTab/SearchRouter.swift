//
//  SearchRouter.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/18.
//

import RIBs

protocol SearchInteractable: Interactable, MyRecordListListener, RecordDetailListener {
    var router: SearchRouting? { get set }
    var listener: SearchListener? { get set }
}

protocol SearchViewControllable: ViewControllable {
    func showSearchResult()
    func hiddenSearchResult()
}

final class SearchRouter: ViewableRouter<SearchInteractable, SearchViewControllable>, SearchRouting {
    
    init(
        interactor: SearchInteractable,
        viewController: SearchViewControllable,
        myRecordListBuildable: MyRecordListBuilder,
        recordDetailBuildable: RecordDetailBuildable
    ) {
        self.myRecordListBuildable = myRecordListBuildable
        self.recordDetailBuildable = recordDetailBuildable
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachMyRecordList(tag: String) {
        if myRecordListRouting != nil {
            return
        }
        let router = myRecordListBuildable.build(withListener: interactor, tag: tag)
        viewController.pushViewController(router.viewControllable, animated: true)
        attachChild(router)
        myRecordListRouting = router
    }
    
    func detachMyRecordList() {
        if let myRecordList = myRecordListRouting {
            viewController.popViewController(animated: true)
            detachChild(myRecordList)
            myRecordListRouting = nil
        }
    }
    
    func attachRecordDetail(data: SearchResult) {
        if recordDetailRouting != nil {
            return
        }
        
        let items = data.items.map { item -> RecordReadDTO.RecordItemReadDTO in
            return RecordReadDTO.RecordItemReadDTO(
                content: item.content,
                isMain: item.isMain
            )
        }
        
        let recordItem = RecordReadDTO(
            id: data.id,
            title: data.title,
            url: data.url,
            items: items,
            tags: data.tags,
            attribute: RecordReadDTO.Attribute.stub(),
            createdAt: data.createdAt.toString(),
            createdBy: data.createdBy
        )
        
        let router = recordDetailBuildable.build(withListener: interactor, data: recordItem, editable: true)
        viewController.pushViewController(router.viewControllable, animated: true)
        attachChild(router)
        recordDetailRouting = router
    }
    
    func detachRecordDetail() {
        if let recordDetail = recordDetailRouting {
            viewController.popViewController(animated: true)
            detachChild(recordDetail)
            recordDetailRouting = nil
        }
    }
    
    // MARK: - Private
    private let myRecordListBuildable: MyRecordListBuildable
    private var myRecordListRouting: MyRecordListRouting?
    
    private let recordDetailBuildable: RecordDetailBuildable
    private var recordDetailRouting: RecordDetailRouting?
}
