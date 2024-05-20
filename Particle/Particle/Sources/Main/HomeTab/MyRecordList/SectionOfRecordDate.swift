//
//  SectionOfRecordDate.swift
//  Particle
//
//  Created by 이원빈 on 2023/10/01.
//

import RxDataSources

struct SectionOfRecordDate {
    var header: String
    var items: [Item]
    
    func reverseItems() -> Self {
        .init(header: header, items: items.reversed())
    }
}

extension SectionOfRecordDate: SectionModelType {
    typealias Item = RecordReadDTO
    
    init(original: SectionOfRecordDate, items: [RecordReadDTO]) {
        self = original
        self.items = items
    }
}
