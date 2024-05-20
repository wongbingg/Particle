//
//  EditRecordUseCase.swift
//  Particle
//
//  Created by 이원빈 on 2023/12/10.
//

import Foundation
import RxSwift

protocol EditRecordUseCase {
    func execute(id: String, updatedModel: RecordCreateDTO) -> Observable<RecordReadDTO>
}

final class DefaultEditRecordUseCase: EditRecordUseCase {
    private let recordRepository: RecordRepository
    
    init(recordRepository: RecordRepository) {
        self.recordRepository = recordRepository
    }
    
    func execute(id: String, updatedModel: RecordCreateDTO) -> Observable<RecordReadDTO> {
        recordRepository.editRecord(id: id, to: updatedModel)
    }
}
