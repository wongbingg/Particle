//
//  FetchMyRecordsByTagUseCase.swift
//  Particle
//
//  Created by 이원빈 on 2023/10/14.
//

import RxSwift

protocol FetchMyRecordsByTagUseCase {
    func execute(tag: String) -> Observable<[SectionOfRecordDate]>
}

final class DefaultFetchMyRecordsByTagUseCase: FetchMyRecordsByTagUseCase {
    private let recordRepository: RecordRepository
    
    init(recordRepository: RecordRepository) {
        self.recordRepository = recordRepository
    }
    
    func execute(tag: String) -> Observable<[SectionOfRecordDate]> {
        recordRepository.getMyRecordsSeparatedByDate(byTag: tag)
    }
}
