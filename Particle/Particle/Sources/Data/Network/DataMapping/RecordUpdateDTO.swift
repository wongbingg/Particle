//
//  RecordUpdateDTO.swift
//  Particle
//
//  Created by 이원빈 on 2023/08/16.
//

struct RecordUpdateDTO {
    let title: String
    let url: String
    let items: [RecordItemUpdateDTO]
    let tags: [String]
    
    struct RecordItemUpdateDTO {
        let content: String
        let isMain: Bool
    }
}
