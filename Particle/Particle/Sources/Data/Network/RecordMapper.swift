//
//  RecordMapper.swift
//  Particle
//
//  Created by 이원빈 on 2023/10/15.
//

import Foundation

protocol RecordMapperProtocol {
    func mapRecords(model: [RecordReadDTO]) -> [SectionOfRecordTag]
    func mapRecords(model: [RecordReadDTO]) -> [SectionOfRecordDate]
}

struct RecordMapper: RecordMapperProtocol {
    
    func mapRecords(model: [RecordReadDTO]) -> [SectionOfRecordTag] {
        guard let userInterestedTags = UserDefaults.standard.object(forKey: "INTERESTED_TAGS") as? [String] else {
            return []
        }
        guard model.isEmpty == false else { return [] }
        var sectionList: [SectionOfRecordTag] = [.init(header: "My", items: model)]
        let tags = userInterestedTags.map { $0.replacingOccurrences(of: "#", with: "")}
        for tag in tags {
            let filteredList = model.filter { $0.tags.contains(tag) }
            if filteredList.isEmpty == false {
                sectionList.append(.init(header: tag, items: filteredList))
            }
        }
        return sectionList
    }
    
    func mapRecords(model: [RecordReadDTO]) -> [SectionOfRecordDate] {
        var list = model
        list.sort { a, b in
            a.fetchDate().timeIntervalSince1970 > b.fetchDate().timeIntervalSince1970
        }
        
        var headers = [String]()
        
        for ele in list {
            let header = ele.fetchDateSectionHeaderString()
            if headers.contains(header) {
                continue
            } else {
                headers.append(header)
            }
        }
        
        var result = [SectionOfRecordDate]()
        
        for header in headers {
            result.append(
                .init(
                    header: header,
                    items: list.filter { $0.fetchDateSectionHeaderString() == header }
                )
            )
        }
        
        return result
    }
}
