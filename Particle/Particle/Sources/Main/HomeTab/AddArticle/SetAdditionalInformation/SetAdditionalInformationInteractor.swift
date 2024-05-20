//
//  SetAdditionalInformationInteractor.swift
//  Particle
//
//  Created by Sh Hong on 2023/07/12.
//

import RIBs
import RxSwift

protocol SetAdditionalInformationRouting: ViewableRouting {
    
}

protocol SetAdditionalInformationPresentable: Presentable {
    var listener: SetAdditionalInformationPresentableListener? { get set }
    
    // 수정하기 모드에서 동작
    func setData(data: RecordReadDTO)
}

protocol SetAdditionalInformationListener: AnyObject {
    func setAdditionalInfoBackButtonTapped()
    func setAdditionalInfoSuccessPost(data: RecordReadDTO)
    func setAdditionalInfoSuccessEdit(data: RecordReadDTO) // 수정모드
}

final class SetAdditionalInformationInteractor: PresentableInteractor<SetAdditionalInformationPresentable>,
                                                SetAdditionalInformationInteractable,
                                                SetAdditionalInformationPresentableListener {
    
    weak var router: SetAdditionalInformationRouting?
    weak var listener: SetAdditionalInformationListener?

    private var disposeBag = DisposeBag()
    private var recordData: RecordReadDTO?
    private let repository: OrganizingSentenceRepository
    private let createRecordUseCase: CreateRecordUseCase
    private let editRecordUseCase: EditRecordUseCase

    init(
        presenter: SetAdditionalInformationPresentable,
        repository: OrganizingSentenceRepository,
        createRecordUseCase: CreateRecordUseCase,
        editRecordUseCase: EditRecordUseCase,
        data: RecordReadDTO? = nil
    ) {
        self.repository = repository
        self.createRecordUseCase = createRecordUseCase
        self.editRecordUseCase = editRecordUseCase
        self.recordData = data
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        /// 수정모드
        if let data = recordData {
            presenter.setData(data: data)
        }
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    // MARK: - SetAdditionalInformationPresentableListener
    
    func setAdditionalInfoBackButtonTapped() {
        listener?.setAdditionalInfoBackButtonTapped()
    }
    
    func setAdditionalInfoNextButtonTapped(title: String, url: String, tags: [String], style: String) {
        
        let requestModel: [RecordCreateDTO.RecordItemCreateDTO] = repository.sentenceFile2.value.map {
            .init(content: $0.sentence, isMain: $0.isRepresent)
        }
        
        let uniqueTags = Array(Set(tags))
        
        let model = RecordCreateDTO(title: title, url: url, items: requestModel, tags: uniqueTags, style: style)
        
        if let recordData = recordData { // 수정모드
            editRecordUseCase.execute(id: recordData.id, updatedModel: model)
                .observe(on: MainScheduler.instance)
                .subscribe { [weak self] result in
                    self?.listener?.setAdditionalInfoSuccessEdit(data: result)
                } onError: { error in
                    Console.error(error.localizedDescription)
                }
                .disposed(by: disposeBag)

        } else {
            
            createRecordUseCase.execute(model: model)
                .observe(on: MainScheduler.instance)
                .subscribe { [weak self]  result in
                    self?.listener?.setAdditionalInfoSuccessPost(data: result)
                } onError: { error in
                    Console.error(error.localizedDescription)
                }
                .disposed(by: disposeBag)
        }
    }
}
