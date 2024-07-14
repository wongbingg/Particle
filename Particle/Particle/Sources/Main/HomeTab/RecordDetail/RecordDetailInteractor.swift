//
//  RecordDetailInteractor.swift
//  Particle
//
//  Created by 이원빈 on 2023/09/02.
//

import RIBs
import RxSwift

protocol RecordDetailRouting: ViewableRouting {
    func attachOrganizingSentence()
    func detachOrganizingSentence()
    func attachSetAdditionalInformation(data: RecordReadDTO)
    func detachSetAdditionalInformation()
    
    func attachRecordDetail(with data: RecordReadDTO)
    func cleanupViews(with updatedData: RecordReadDTO)
}

protocol RecordDetailPresentable: Presentable {
    var listener: RecordDetailPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
    func showErrorAlert(description: String)
    func showSuccessAlert()
}

protocol RecordDetailListener: AnyObject {
    func recordDetailCloseButtonTapped()
}

final class RecordDetailInteractor: PresentableInteractor<RecordDetailPresentable>,
                                    RecordDetailInteractable,
                                    RecordDetailPresentableListener {
     
    weak var router: RecordDetailRouting?
    weak var listener: RecordDetailListener?
    
    private var disposeBag = DisposeBag()
    private let recordData: RecordReadDTO
    private let deleteRecordUseCase: DeleteRecordUseCase
    private let addHeartToRecordUseCase: AddHeartToRecordUseCase
    private let deleteHeartFromRecordUseCase: DeleteHeartFromRecordUseCase
    
    init(
        presenter: RecordDetailPresentable,
        deleteRecordUseCase: DeleteRecordUseCase,
        addHeartToRecordUseCase: AddHeartToRecordUseCase,
        deleteHeartFromRecordUseCase: DeleteHeartFromRecordUseCase,
        data: RecordReadDTO
    ) {
        self.deleteRecordUseCase = deleteRecordUseCase
        self.addHeartToRecordUseCase = addHeartToRecordUseCase
        self.deleteHeartFromRecordUseCase = deleteHeartFromRecordUseCase
        self.recordData = data
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    // MARK: - RecordDetailPresentableListener
    
    func recordDetailCloseButtonTapped() {
        listener?.recordDetailCloseButtonTapped()
    }
    
    func recordDetailDeleteButtonTapped(with id: String) {
        deleteRecordUseCase.execute(id: id)
            .observeOn(MainScheduler.instance)
            .subscribe { [weak self] deletedRecordId in
                if id == deletedRecordId {
                    self?.presenter.showSuccessAlert()
                    // TODO: Listener 로 보내서 MyRecordList RIB 에서도 리프레쉬 되도록 구현해야 함.
                }
            } onError: { [weak self] error in
                if case DataTransferError.resolvedNetworkFailure(let errorResponse as ErrorResponse) = error {
                    self?.presenter.showErrorAlert(description: errorResponse.toDomain())
                } else {
                    self?.presenter.showErrorAlert(description: "알 수 없는 에러가 발생했습니다.\n다시 시도해주세요\n\(error.localizedDescription)")
                }
            }
            .disposed(by: disposeBag)
    }
    
    func recordDetailReportButtonTapped(with id: String) {
//        reportRecordUseCase.execute(id: id)
//            .observe(on: MainScheduler.instance)
//            .subscribe { [weak self] isSuccessReport in
//                if isSuccessReport {
//                    self?.presenter.showSuccessAlert()
//                }
//            } onError: { [weak self] error in
//                if case DataTransferError.resolvedNetworkFailure(let errorResponse as ErrorResponse) = error {
//                    self?.presenter.showErrorAlert(description: errorResponse.toDomain())
//                } else {
//                    self?.presenter.showErrorAlert(description: "알 수 없는 에러가 발생했습니다.\n다시 시도해주세요\n\(error.localizedDescription)")
//                }
//            }
//            .disposed(by: disposeBag)
    }
    
    func recordDetailSaveButtonTapped(with id: String) {
        // TODO: 아티클 저장액션
        // 코어데이터에 저장? 서버에 저장?
    }
    
    func recordDetailEditButtonTapped(with id: String) {
        router?.attachOrganizingSentence()
    }
    
    func recordDetailHeartButtonTapped(with id: String, isHeart: Bool) {
        do {
            isHeart ?
            try addHeartToRecordUseCase.execute(id: id) :
            try deleteHeartFromRecordUseCase.execute(id: id)
        } catch {
            Console.error(error.localizedDescription)
        }
    }
    
    // MARK: - OrganizingSentenceListener
    
    func organizingSentenceNextButtonTapped() {
        router?.attachSetAdditionalInformation(data: recordData)
    }
    
    func organizingSentenceBackButtonTapped() {
        router?.detachOrganizingSentence()
    }
    
    // MARK: - SetAdditionalInformationListener
    
    func setAdditionalInfoBackButtonTapped() {
        router?.detachSetAdditionalInformation()
    }
        
    func setAdditionalInfoSuccessEdit(data: RecordReadDTO) {
        router?.cleanupViews(with: data)
    }
    
    func setAdditionalInfoSuccessPost(data: RecordReadDTO) { }
}
