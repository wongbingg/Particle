//
//  MyRecordListBuilder.swift
//  Particle
//
//  Created by 이원빈 on 2023/09/03.
//

import RIBs

protocol MyRecordListDependency: Dependency {
    var recordRepository: RecordRepository { get }
}

final class MyRecordListComponent: Component<MyRecordListDependency> {

    fileprivate var fetchMyRecordsByTagUseCase: FetchMyRecordsByTagUseCase {
        return DefaultFetchMyRecordsByTagUseCase(recordRepository: dependency.recordRepository)
    }
    
    fileprivate var fetchMyRecordsByDateUseCase: FetchMyRecordsByDateUseCase {
        return DefaultFetchMyRecordsByDateUseCase(recordRepository: dependency.recordRepository)
    }
}

// MARK: - Builder

protocol MyRecordListBuildable: Buildable {
    func build(withListener listener: MyRecordListListener, tag: String) -> MyRecordListRouting
}

final class MyRecordListBuilder: Builder<MyRecordListDependency>, MyRecordListBuildable {

    override init(dependency: MyRecordListDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: MyRecordListListener, tag: String) -> MyRecordListRouting {
        let component = MyRecordListComponent(dependency: dependency)
        let viewController = MyRecordListViewController()
        
        let interactor = MyRecordListInteractor(
            presenter: viewController,
            tag: tag,
            fetchMyRecordsByTagUseCase: component.fetchMyRecordsByTagUseCase,
            fetchMyRecordsByDateUseCase: component.fetchMyRecordsByDateUseCase
        )
        interactor.listener = listener
        
        let recordDetailBuilder = RecordDetailBuilder(dependency: component)
        
        return MyRecordListRouter(
            interactor: interactor,
            viewController: viewController,
            recordDetailBuildable: recordDetailBuilder
        )
    }
}

extension MyRecordListComponent: RecordDetailDependency {
    var recordRepository: RecordRepository {
        return dependency.recordRepository
    }
}
