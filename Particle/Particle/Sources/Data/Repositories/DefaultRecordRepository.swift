//
//  DefaultRecordRepository.swift
//  Particle
//
//  Created by 이원빈 on 2023/10/09.
//

import Foundation
import RxSwift


final class DefaultRecordRepository {
    
    private let recordDataSource: RecordDataSource
    private let recordMapper: RecordMapperProtocol
    
    init(
        recordDataSource: RecordDataSource,
        recordMapper: RecordMapperProtocol
    ) {
        self.recordDataSource = recordDataSource
        self.recordMapper = recordMapper
    }
}

extension DefaultRecordRepository: RecordRepository {
    
    func getMyRecords() -> RxSwift.Observable<[RecordReadDTO]> {
        /// 원래는 Domain 모델로 변환해주는 작업을 수행하는 범위
        return recordDataSource.getMyRecords()
    }
    
    func getRecordBy(id: String) -> RxSwift.Observable<RecordReadDTO> {
        return recordDataSource.getRecordBy(id: id)
    }
    
    func editRecord(id: String, to updatedModel: RecordCreateDTO) -> RxSwift.Observable<RecordReadDTO> {
        return recordDataSource.editRecord(id: id, to: updatedModel)
    }
    
    func getMyRecordsSeparatedByTag() -> RxSwift.Observable<[SectionOfRecordTag]> {
        return recordDataSource.getMyRecords()
            .map { [weak self] data in
                guard let self = self else { return [] }
                return self.recordMapper.mapRecords(model: data)
            }
    }
    
    func getMyRecordsSeparatedByDate() -> RxSwift.Observable<[SectionOfRecordDate]> {
        return recordDataSource.getMyRecords()
            .map { [weak self] data in
                guard let self = self else { return [] }
                return self.recordMapper.mapRecords(model: data)
            }
    }
    
    func getMyRecordsSeparatedByDate(byTag: String) -> RxSwift.Observable<[SectionOfRecordDate]> {
        return recordDataSource.getRecordsBy(tag: byTag)
            .map { [weak self] data in
                guard let self = self else { return [] }
                return self.recordMapper.mapRecords(model: data)
            }
    }
    
    func getRecordsBy(tag: String) -> RxSwift.Observable<[RecordReadDTO]> {
        return recordDataSource.getRecordsBy(tag: tag)
    }
    
    func createRecord(record: RecordCreateDTO) -> RxSwift.Observable<RecordReadDTO> {
        return recordDataSource.createRecord(record: record)
    }
    
    func deleteRecord(recordId: String) -> RxSwift.Observable<String> {
        return recordDataSource.deleteRecord(recordId: recordId)
    }
}
