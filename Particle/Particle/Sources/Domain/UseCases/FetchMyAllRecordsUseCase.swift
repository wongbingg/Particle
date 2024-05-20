//
//  FetchMyAllRecordsUseCase.swift
//  Particle
//
//  Created by 이원빈 on 2023/10/14.
//

import Foundation
import RxSwift

protocol FetchMyAllRecordsUseCase {
    func execute() -> Observable<[SectionOfRecordTag]>
}

final class DefaultFetchMyAllRecordsUseCase: FetchMyAllRecordsUseCase {
    private let recordRepository: RecordRepository
    
    init(recordRepository: RecordRepository) {
        self.recordRepository = recordRepository
    }
    
    func execute() -> Observable<[SectionOfRecordTag]> {
        recordRepository.getMyRecordsSeparatedByTag()
    }
}
