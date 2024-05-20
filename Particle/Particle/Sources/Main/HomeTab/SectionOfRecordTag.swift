//
//  SectionOfRecordTag.swift
//  Particle
//
//  Created by 이원빈 on 2023/10/01.
//

import RxDataSources

struct SectionOfRecordTag {
    var header: String
    var items: [Item]
}

extension SectionOfRecordTag: SectionModelType {
    typealias Item = RecordReadDTO
    
    init(original: SectionOfRecordTag, items: [RecordReadDTO]) {
        self = original
        self.items = items
    }
}
