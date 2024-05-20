//
//  FetchRecordByIdUseCase.swift
//  Particle
//
//  Created by 이원빈 on 2023/12/10.
//

import Foundation
import RxSwift

protocol FetchRecordByIdUseCase {
    func execute(id: String) -> Observable<RecordReadDTO>
}

final class DefaultFetchRecordByIdUseCase: FetchRecordByIdUseCase {
    private let recordRepository: RecordRepository
    
    init(recordRepository: RecordRepository) {
        self.recordRepository = recordRepository
    }
    
    func execute(id: String) -> Observable<RecordReadDTO> {
        recordRepository.getRecordBy(id: id)
    }
}
