//
//  RecordCreateDTO.swift
//  Particle
//
//  Created by 이원빈 on 2023/08/16.
//

struct RecordCreateDTO: Codable {
    let title: String
    let url: String
    let items: [RecordItemCreateDTO]
    let tags: [String]
    let style: String // TEXT or CARD
    
    struct RecordItemCreateDTO: Codable {
        let content: String
        let isMain: Bool
        
        func encodeForCoreData() -> String {
            "\(content)%\(isMain ? "T" : "F")"
        }
    }
}
