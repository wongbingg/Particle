//
//  SearchResult.swift
//  Particle
//
//  Created by 홍석현 on 11/23/23.
//

import Foundation

struct SearchResult {
    let id: String
    let title: String
    let url: String
    let items: [Item]
    let tags: [String]
    let createdAt: Date
    let createdBy: String
}

struct Item {
    let content: String
    let isMain: Bool
}
