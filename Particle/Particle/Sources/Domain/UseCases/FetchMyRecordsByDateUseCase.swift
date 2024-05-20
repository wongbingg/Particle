//
//  FetchMyRecordsByDateUseCase.swift
//  Particle
//
//  Created by 이원빈 on 2023/10/15.
//

import RxSwift

protocol FetchMyRecordsByDateUseCase {
    func execute() -> Observable<[SectionOfRecordDate]>
}

final class DefaultFetchMyRecordsByDateUseCase: FetchMyRecordsByDateUseCase {
    private let recordRepository: RecordRepository
    
    init(recordRepository: RecordRepository) {
        self.recordRepository = recordRepository
    }
    
    func execute() -> RxSwift.Observable<[SectionOfRecordDate]> {
        recordRepository.getMyRecordsSeparatedByDate()
    }
}
