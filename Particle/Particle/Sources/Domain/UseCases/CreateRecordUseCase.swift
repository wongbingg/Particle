//
//  CreateRecordUseCase.swift
//  Particle
//
//  Created by 이원빈 on 2023/10/15.
//

import RxSwift

protocol CreateRecordUseCase {
    func execute(model: RecordCreateDTO) -> Observable<RecordReadDTO>
}

final class DefaultCreateRecordUseCase: CreateRecordUseCase {
    private let recordRepository: RecordRepository
    
    init(recordRepository: RecordRepository) {
        self.recordRepository = recordRepository
    }
    
    func execute(model: RecordCreateDTO) -> Observable<RecordReadDTO> {
        recordRepository.createRecord(record: model)
    }
}
