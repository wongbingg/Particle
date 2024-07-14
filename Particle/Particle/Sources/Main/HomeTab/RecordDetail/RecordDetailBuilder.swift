//
//  RecordDetailBuilder.swift
//  Particle
//
//  Created by 이원빈 on 2023/09/02.
//

import RIBs

protocol RecordDetailDependency: Dependency {
    var recordRepository: RecordRepository { get }
    var userRepository: UserRepository { get }
}

final class RecordDetailComponent: Component<RecordDetailDependency>,
                                   OrganizingSentenceDependency,
                                   SetAdditionalInformationDependency {
    
    var organizingSentenceRepository: OrganizingSentenceRepository = OrganizingSentenceRepositoryImp()
    var recordRepository: RecordRepository {
        return dependency.recordRepository
    }
    
    var userRepository: UserRepository {
        return dependency.userRepository
    }
    
    fileprivate var deleteRecordUseCase: DeleteRecordUseCase {
        return DefaultDeleteRecordUseCase(recordRepository: dependency.recordRepository)
    }
    var addHeartToRecordUseCase: AddHeartToRecordUseCase {
        return DefaultAddHeartToRecordUseCase(userRepository: dependency.userRepository)
    }
    var deleteHeartFromRecordUseCase: DeleteHeartFromRecordUseCase {
        return DefaultDeleteHeartFromRecordUseCase(userRepository: dependency.userRepository)
    }
}

// MARK: - Builder

protocol RecordDetailBuildable: Buildable {
    func build(
        withListener listener: RecordDetailListener,
        data: RecordReadDTO,
        editable: Bool) -> RecordDetailRouting
}

final class RecordDetailBuilder: Builder<RecordDetailDependency>, RecordDetailBuildable {

    override init(dependency: RecordDetailDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: RecordDetailListener,
               data: RecordReadDTO,
               editable: Bool) -> RecordDetailRouting {
        
        let component = RecordDetailComponent(dependency: dependency)
        let viewController = RecordDetailViewController(data: data, editable: editable)
        let interactor = RecordDetailInteractor(
            presenter: viewController,
            deleteRecordUseCase: component.deleteRecordUseCase,
            addHeartToRecordUseCase: component.addHeartToRecordUseCase,
            deleteHeartFromRecordUseCase: component.deleteHeartFromRecordUseCase,
            data: data
        )
        interactor.listener = listener
        
        component.organizingSentenceRepository.sentenceFile2.accept(data.items.map {
            .init(sentence: $0.content, isRepresent: $0.isMain)
        })
        
        let organizingSentenceBuilder = OrganizingSentenceBuilder(dependency: component)
        let setAdditionalInformationBuilder = SetAdditionalInformationBuilder(dependency: component)
        
        return RecordDetailRouter(
            interactor: interactor,
            viewController: viewController,
            organizingSentenceBuildable: organizingSentenceBuilder,
            setAdditionalInformationBuildable: setAdditionalInformationBuilder
        )
    }
}
