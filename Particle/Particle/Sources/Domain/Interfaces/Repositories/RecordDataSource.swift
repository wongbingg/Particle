//
//  RecordDataSource.swift
//  Particle
//
//  Created by 이원빈 on 2023/10/09.
//

import Foundation
import RxSwift

protocol RecordDataSource {
    func getMyRecords() -> Observable<[RecordReadDTO]>
    func getRecordBy(id: String) -> Observable<RecordReadDTO>
    func editRecord(id: String, to updatedModel: RecordCreateDTO) -> Observable<RecordReadDTO>
    func getRecordsBy(tag: String) -> Observable<[RecordReadDTO]>
    func createRecord(record: RecordCreateDTO) -> Observable<RecordReadDTO>
    func deleteRecord(recordId: String) -> Observable<String>
}

