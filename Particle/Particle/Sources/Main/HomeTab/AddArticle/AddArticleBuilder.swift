//
//  AddArticleBuilder.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/10.
//

import RIBs

protocol AddArticleDependency: Dependency {
    var addArticleViewController: ViewControllable { get }
    var recordRepository: RecordRepository { get }
}

final class AddArticleComponent: Component<AddArticleDependency> {
    var repository = OrganizingSentenceRepositoryImp()
    
    fileprivate var addArticleViewController: ViewControllable {
        return dependency.addArticleViewController
    }
    
    var recordRepository: RecordRepository {
        return dependency.recordRepository
    }
}

// MARK: - Builder

protocol AddArticleBuildable: Buildable {
    func build(withListener listener: AddArticleListener) -> AddArticleRouting
}

final class AddArticleBuilder: Builder<AddArticleDependency>, AddArticleBuildable {
    
    
    override init(dependency: AddArticleDependency) {
        super.init(dependency: dependency)
    }
    
    func build(withListener listener: AddArticleListener) -> AddArticleRouting {
        let component = AddArticleComponent(dependency: dependency)
        
        let interactor = AddArticleInteractor()
        interactor.listener = listener
        
        let photoPickerBuilder = PhotoPickerBuilder(dependency: component)
        let selectSentenceBuilder = SelectSentenceBuilder(dependency: component)
        let organizingSentenceBuilder = OrganizingSentenceBuilder(dependency: component)
        let setAdditionalInformationBuilder = SetAdditionalInformationBuilder(dependency: component)
        let recordDetailBuilder = RecordDetailBuilder(dependency: component)
        
        return AddArticleRouter(
            interactor: interactor,
            viewController: component.addArticleViewController,
            photoPickerBuildable: photoPickerBuilder,
            selectSentenceBuildable: selectSentenceBuilder,
            organizingSentenceBuildable: organizingSentenceBuilder,
            setAdditionalInformationBuildable: setAdditionalInformationBuilder,
            recordDetailBuildable: recordDetailBuilder
        )
    }
}

extension AddArticleComponent: PhotoPickerDependency,
                               SelectSentenceDependency,
                               OrganizingSentenceDependency,
                               SetAdditionalInformationDependency,
                               RecordDetailDependency {
    
    var organizingSentenceRepository: OrganizingSentenceRepository {
        return repository
    }
}
