//
//  MyRecordListRouter.swift
//  Particle
//
//  Created by 이원빈 on 2023/09/03.
//

import RIBs

protocol MyRecordListInteractable: Interactable, RecordDetailListener {
    var router: MyRecordListRouting? { get set }
    var listener: MyRecordListListener? { get set }
}

protocol MyRecordListViewControllable: ViewControllable {}

final class MyRecordListRouter: ViewableRouter<MyRecordListInteractable, MyRecordListViewControllable>,
                                MyRecordListRouting {

    init(
        interactor: MyRecordListInteractable,
        viewController: MyRecordListViewControllable,
        recordDetailBuildable: RecordDetailBuildable
    ) {
        self.recordDetailBuildable = recordDetailBuildable
        super.init(
            interactor: interactor,
            viewController: viewController
        )
        interactor.router = self
    }
    
    // MARK: - RecordDetail RIB
    
    func attachRecordDetail(data: RecordReadDTO) {
            if recordDetailRouting != nil {
                return
            }
            let router = recordDetailBuildable.build(withListener: interactor, data: data, editable: true)
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
    
    private let recordDetailBuildable: RecordDetailBuildable
    private var recordDetailRouting: RecordDetailRouting?
}
