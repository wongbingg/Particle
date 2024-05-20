//
//  SearchResultDTO.swift
//  Particle
//
//  Created by 홍석현 on 11/23/23.
//

import Foundation

struct SearchResultDTO: Decodable {
    let id: String
    let title: String
    let url: String
    let items: [ItemDTO]
    let tags: [String]
    let createdAt: String
    let createdBy: String
}

struct ItemDTO: Codable {
    let content: String
    let isMain: Bool
}

extension ItemDTO {
    func toDomain() -> Item {
        return Item(content: content, isMain: isMain)
    }
}

extension SearchResultDTO {
    func toDomain() -> SearchResult {
        return SearchResult(
            id: id,
            title: title,
            url: url,
            items: items.map { $0.toDomain() },
            tags: tags,
            createdAt: Date(),
            createdBy: createdBy
        )
    }
}
