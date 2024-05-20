//
//  SetAdditionalInformationBuilder.swift
//  Particle
//
//  Created by Sh Hong on 2023/07/12.
//

import RIBs

protocol SetAdditionalInformationDependency: Dependency {
    var organizingSentenceRepository: OrganizingSentenceRepository { get }
    var recordRepository: RecordRepository { get }
}

final class SetAdditionalInformationComponent: Component<SetAdditionalInformationDependency> {
    var organizingSentenceRepository: OrganizingSentenceRepository {
        dependency.organizingSentenceRepository
    }
    
    fileprivate var createRecordUseCase: CreateRecordUseCase {
        return DefaultCreateRecordUseCase(recordRepository: dependency.recordRepository)
    }
    
    fileprivate var editRecordUseCase: EditRecordUseCase {
        return DefaultEditRecordUseCase(recordRepository: dependency.recordRepository)
    }
}

// MARK: - Builder

protocol SetAdditionalInformationBuildable: Buildable {
    func build(withListener listener: SetAdditionalInformationListener, data: RecordReadDTO?) -> SetAdditionalInformationRouting
}

final class SetAdditionalInformationBuilder: Builder<SetAdditionalInformationDependency>, SetAdditionalInformationBuildable {

    override init(dependency: SetAdditionalInformationDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: SetAdditionalInformationListener, data: RecordReadDTO? = nil) -> SetAdditionalInformationRouting {
        let component = SetAdditionalInformationComponent(dependency: dependency)
        let viewController = SetAdditionalInformationViewController()
        let interactor = SetAdditionalInformationInteractor(
            presenter: viewController,
            repository: component.organizingSentenceRepository,
            createRecordUseCase: component.createRecordUseCase,
            editRecordUseCase: component.editRecordUseCase,
            data: data
        )
        interactor.listener = listener
        return SetAdditionalInformationRouter(interactor: interactor, viewController: viewController)
    }
}
